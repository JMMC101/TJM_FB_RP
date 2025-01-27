#version 150

#moj_import <minecraft:light.glsl>
#moj_import <minecraft:fog.glsl>
#moj_import <frostbite:matrices.glsl>

#define SKYBOX_SIZE_X 512*3*3
#define SKYBOX_SIZE_Y 512*3*2

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
flat out float v_offset;
flat out int object_type;

out vec2 pos_xz_0;
out vec2 pos_xz_1;
out vec2 pos_xz_2;
//flat out vec2 pos_xz_0;
//flat out vec2 pos_xz_1;
//flat out vec2 pos_xz_2;

#define std_glpos_calc gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0)

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

    ivec4 icolor = ivec4(texture(Sampler0, UV0) * 255.0);
    int alpha = icolor.a;

    if ((alpha < 9) && (alpha > 0)) {
        debug_color = vec4(-skybox_vertex_positions_array[alpha-1], 1.0);
        gl_Position = ProjMat * ModelViewMat * vec4(rotateX(GameTime*16.0) * -skybox_vertex_positions_array[alpha-1]*128.0, 1.0);

        object_type = 1;
    } else if (ivec2(Color.rg * 255.0) == ivec2(94, 48)) {
        std_glpos_calc;
        //pos_xz_0 = pos_xz_1 = pos_xz_2 = vec2(0.0);
        switch ((gl_VertexID) % 4) {
            case 0:
            pos_xz_0 = (Position.xz * 255.0);
            debug_color = vec4(1.0, 0.0, 0.0, 1.0);
            break;

            case 1:
            pos_xz_1 = (Position.xz * 255.0);
            debug_color = vec4(0.0, 1.0, 0.0, 1.0);
            break;

            case 2:
            pos_xz_2 = (Position.xz * 255.0);
            debug_color = vec4(1.0, 0.0, 1.0, 1.0);
            break;
        }
        //debug_color = vec4(Position.xz, 0.0, 1.0);

        if (bool(gl_VertexID&1^1)) {
            object_type = 8 + ((gl_VertexID&2) >> 1);
        } else {
            return;
        }
    } else {
        debug_color = vec4(1.0);
        std_glpos_calc;
        object_type = 0;
    }
}
