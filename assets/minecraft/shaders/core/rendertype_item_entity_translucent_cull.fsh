#version 150

#moj_import <minecraft:fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;
in vec2 texCoord2;

in vec4 debug_color;

flat in int object_type;

in vec2 pos_xz_0;
in vec2 pos_xz_1;
in vec2 pos_xz_2;

out vec4 fragColor;

void main() {
    //fragColor = debug_color; return;
    switch (object_type) {
        case 0: // vanilla items
        vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
        if (color.a < 0.1) {
            discard;
        }
        fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
        gl_FragDepth = gl_FragCoord.z;
        break;

        case 1: // simple skyboxes
        fragColor = vec4(texture(Sampler0, texCoord0).rgb, 1.0);
        gl_FragDepth = 0.9999;
        break;

        case 2: // switching skyboxes
        break;

        case 8:
        //switch (int(gl_FragCoord.x) & 3) {
        //    case 0:
        //    fragColor = vec4(1.0, 1.0, 0.0, 1.0);
        //    break;

        //    case 1:
        //    fragColor = vec4(pos_xz_0, 0.0, 1.0);
        //    break;

        //    case 2:
        //    fragColor = vec4(pos_xz_1, 0.0, 1.0);
        //    break;

        //    case 3:
        //    fragColor = vec4(pos_xz_2, 0.0, 1.0);
        //    break;
        //}
        
        fragColor = vec4(
            //floor((pos_xz_2.x - pos_xz_1.x) * 16.0) / 16.0,
            //floor((pos_xz_1.y - pos_xz_0.y) * 16.0) / 16.0,
            //(pos_xz_2 - pos_xz_0) * 32.0,
            (pos_xz_0 - pos_xz_2) / 255.0,
            0.0,
            1.0
        );

        //fragColor = debug_color;
        gl_FragDepth = gl_FragCoord.z;
        break;
        case 9:
        fragColor = vec4(0.0, 1.0, 1.0, 1.0);
        gl_FragDepth = gl_FragCoord.z;
        break;
    }
}
