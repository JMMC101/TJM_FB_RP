#version 150

#moj_import <minecraft:light.glsl>
#moj_import <minecraft:fog.glsl>
#moj_import <frostbite:matrices.glsl>

#define halfpi  1.5707963267948966
#define pi      3.141592653589793
#define tau     6.283185307179586

#define SKYBOX_TILE_SIZE 256*3
#define SKYBOX_SIZE_X    256*3 *3
#define SKYBOX_SIZE_Y    256*3 *2

#define MOON_TEXTURE_HALFSIZE 16
#define MOON_TEXTURE_SIZE     32

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform float GameTime;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec2 texCoord1;
out vec2 texCoord2;

vec3[] skybox_vertex_positions_array = vec3[] (
    vec3(-1.0, -1.0,  1.0),
    vec3( 1.0, -1.0,  1.0),
    vec3(-1.0, -1.0, -1.0),
    vec3( 1.0, -1.0, -1.0),

    vec3(-1.0,  1.0, -1.0),
    vec3( 1.0,  1.0, -1.0),
    vec3(-1.0,  1.0,  1.0),
    vec3( 1.0,  1.0,  1.0)
);


out vec4 debug_color;


/*
    0 - vanilla items
    1 - simple skyboxes
    2 - complex skybox
    3 - foggy skybox
    //
    8 - circle part A
    9 - circle part B
*/
flat out int object_type;
out vec3 world_pos;

out vec3 pos_xz_0;
out vec3 pos_xz_1;
out vec3 pos_xz_2;
out vec2 moon_center_uv;

#define std_glpos_calc gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0)

float round(float x) {
    return floor(x + 0.5);
}
vec2 round(vec2 v) {
    return vec2(
        round(v.x),
        round(v.y)
    );
}
vec3 round(vec3 v) {
    return vec3(
        round(v.x),
        round(v.y),
        round(v.z)
    );
}


void setup_size_sending() {
    pos_xz_0 = vec3(0.0);
    pos_xz_1 = vec3(0.0);
    pos_xz_2 = vec3(0.0);
    switch ((gl_VertexID) % 4) {
        case 0:
        pos_xz_0 = vec3(Position.xz, 1.0);
        break;

        case 1:
        case 3:
        pos_xz_1 = vec3(Position.xz, 1.0);
        break;

        case 2:
        pos_xz_2 = vec3(Position.xz, 1.0);
        break;
    }
}

void main() {
    
    vertexDistance = fog_distance(Position, FogShape);
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color) * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
    texCoord1 = UV1;
    texCoord2 = UV2;

    ivec4 tex_icolor = ivec4(texture(Sampler0, UV0) * 255.0);  // was used before but not anymore
    int alpha = tex_icolor.a;

    ivec3 dyed_icolor = ivec3(Color.rgb * 255.0);

    if (dyed_icolor.rg == ivec2(23, 101)) {

        if (GameTime > 0.9999) return;

        vec3 vertex_pos = rotateZ(-GameTime*2.0) * -skybox_vertex_positions_array[(alpha & 0xF)-1];
        world_pos = vertex_pos;
        
        gl_Position = ProjMat * ModelViewMat * vec4(vertex_pos*128.0, 1.0);
        debug_color = vec4(-gl_Position.w / 128.0, gl_Position.w / 128.0, 0.0, 1.0);
        setup_size_sending();

        vec2 texture_size = textureSize(Sampler0, 0);

        moon_center_uv = (round(UV0*texture_size) + vec2(
            -float(alpha >> 6)        * SKYBOX_TILE_SIZE  + MOON_TEXTURE_HALFSIZE + dyed_icolor.b*MOON_TEXTURE_SIZE + SKYBOX_SIZE_X,
            -float((alpha >> 4) & 3 ) * SKYBOX_TILE_SIZE  + MOON_TEXTURE_HALFSIZE
        )) / texture_size;

        object_type = 2;

    } else if (dyed_icolor.rg == ivec2(23, 101)) {
        vec3 vertex_pos = -skybox_vertex_positions_array[(alpha & 0xF)-1];
        world_pos = vertex_pos;

        gl_Position = ProjMat * ModelViewMat * vec4(vertex_pos*128.0, 1.0);
        //debug_color = vec4(-gl_Position.w / 128.0, gl_Position.w / 128.0, 0.0, 1.0);
        setup_size_sending();

        object_type = 3;

    } else {
        debug_color = vec4(1.0);
        std_glpos_calc;
        object_type = 0;
    }
}
