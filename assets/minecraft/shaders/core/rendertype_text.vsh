#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <frostbite:waves.glsl>
#moj_import <frostbite:matching.glsl>
#moj_import <frostbite:noise.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

#define TEMP_STATIC_ICON            ((48 << 16) | (84 << 8) | 61)
#define TEMP_VIBRATING_ICON         ((10 << 16) | (78 << 8) | 69)
#define TEMP_SLIGHT_VIBRATING_ICON  ((18 << 16) | (96 << 8) | 63)

#define RESCALE_TRIGGER (42 << 16) | (69 << 8) | 0
#define RESCALE_TRIGGER_SHADOW (10 << 16) | (17 << 8) | 0

C:\Users\admin\AppData\Roaming\.minecraft\resourcepacks\tjm_rp_2025_a\assets\minecraft\shaders\core
uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform float GameTime;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec2 faceUV;
flat out int object_type;


const vec2[] UVS = vec2[](
    vec2(0.0,  0.0),
    vec2(1.0,  0.0),
    vec2(1.0,  1.0),
    vec2(0.0,  1.0)
);

#define std_glpos_calc gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0)

void main() {
    // for book backgrounds
    vec2 PositionScaler = vec2(1.0);
    float guiScale = (round(ScreenSize.x * ProjMat[0][0] / 2));

    faceUV = UVS[gl_VertexID % 4];
    vec2 texture_size = textureSize(Sampler0, 0);
    if ((texture_size.x == texture_size.y) && (texture_size.x > 2048.0)) object_type = 1;  // it's probably a map contents
    else object_type = 0;  // it's probably some regular text, at least could be treated as such

    texCoord0 = UV0;
    vertexDistance = fog_distance(Position, FogShape);
    float x_pos_offset = 0.0;
    float y_pos_offset = 0.0;
    float z_pos_offset = 0.0;

    int icolor = pack_vec(Color.rgb);
    
    switch(icolor) {

        case TEMP_STATIC_ICON:
        vertexColor = vec4(1.0); object_type = 2;
        z_pos_offset = 0.3;
        break;

        case TEMP_VIBRATING_ICON:
        vertexColor = vec4(1.0); object_type = 2;
        z_pos_offset = 0.3;
        y_pos_offset = triangular_wave(GameTime*13884.4437)*0.02-0.01;
        break;

        case TEMP_SLIGHT_VIBRATING_ICON:
        vertexColor = vec4(1.0); object_type = 2;
        z_pos_offset = 0.3;
        float t = GameTime*10388.4437;
        y_pos_offset = (white_noise(floor(t*2.0 + 0.25)) > 0.82) ? triangular_wave(t)*0.02-0.01 : 0.0;
        break;

        case RESCALE_TRIGGER:
        std_glpos_calc;
        gl_Position.xy *= 0.25;
        gl_Position.y += -1.0 + 123.5/ScreenSize.y*guiScale;
        vertexColor = vec4(vec3(1.0), Color.a);
        return;
        case RESCALE_TRIGGER_SHADOW:
        std_glpos_calc;
        gl_Position.xy *= 0.25;
        gl_Position.y += -1.0 + 123.5/ScreenSize.y*guiScale;
        vertexColor = vec4(vec3(0.25), Color.a);
        return;

        default:
        vertexColor = texture(Sampler2, UV2 / 256.0) * Color;
        //vertexColor = vec4(UV2 / 256.0, 0.25, 1.0);
    }
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    gl_Position.x += x_pos_offset;
    gl_Position.y += y_pos_offset;
    gl_Position.z += z_pos_offset;
}
