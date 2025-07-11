#version 150

#moj_import <minecraft:fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 faceUV;
flat in int object_type;

out vec4 fragColor;

void main() {

    vec4 color = texture(Sampler0, texCoord0);
    if (color.a < 0.1 || color.rgb == vec3(0.0,1.0,1.0)) {
        discard;
    }

    if (object_type == 2) {
        fragColor = color; return;
    }

    fragColor = linear_fog(color * vertexColor * ColorModulator, vertexDistance, FogStart, FogEnd, FogColor);
}
