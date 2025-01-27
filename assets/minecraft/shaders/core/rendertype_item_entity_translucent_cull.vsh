#version 150

#moj_import <minecraft:light.glsl>
#moj_import <minecraft:fog.glsl>
#moj_import <frostbite:matrices.glsl>

#define SKYBOX_TILE_SIZE 256*3
#define SKYBOX_SIZE_X    256*3 *4
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
out vec2 face_uv;


/*
    0 - vanilla items
    1 - simple skyboxes
    //
    8 - circle part A
    9 - circle part B
*/
//flat out float v_offset;
flat out int object_type;
//out float height;
out vec3 world_pos;

out vec3 pos_xz_0;
out vec3 pos_xz_1;
out vec3 pos_xz_2;
//flat out vec2 pos_xz_0;
//flat out vec2 pos_xz_1;
//flat out vec2 pos_xz_2;

#define std_glpos_calc gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0)

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

    //debug_color = vec4(
    //    vec3(float(gl_VertexID % 24) / 24.0),
    //    1.0
    //);

    ivec4 tex_icolor = ivec4(texture(Sampler0, UV0) * 255.0);
    int alpha = tex_icolor.a;

    ivec3 dyed_icolor = ivec3(Color.rgb * 255.0);

    if (dyed_icolor.rg == ivec2(23, 101)) {
        debug_color = vec4(-skybox_vertex_positions_array[(alpha & 0xF)-1], 1.0);
        vec3 vertex_pos = rotateX(GameTime*160.0) * -skybox_vertex_positions_array[(alpha & 0xF)-1];
        world_pos = vertex_pos;
        
        gl_Position = ProjMat * ModelViewMat * vec4(vertex_pos*128.0, 1.0);
        setup_size_sending();

        object_type = 2;


    } else if (dyed_icolor.rg == ivec2(94, 48)) {
        std_glpos_calc;
        setup_size_sending();
        //debug_color = vec4(Position.xz, 0.0, 1.0);

        object_type = 8; return;
        //if (bool(gl_VertexID&1^1)) {
        //    object_type = 8 + ((gl_VertexID&2) >> 1);
        //} else {
        //    return;
        //}
    } else {
        debug_color = vec4(1.0);
        std_glpos_calc;
        object_type = 0;
    }
}
