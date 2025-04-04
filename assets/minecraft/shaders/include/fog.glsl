#version 150

#moj_import<frostbite:color_correction.glsl>

vec4 linear_fog(vec4 inColor, float vertexDistance, float fogStart, float fogEnd, vec4 fogColor) {
    vec4 correctedColor = vec4(color_correct(inColor.rgb), inColor.a);
    float MfogStart = fogStart * 0.1;

    if (vertexDistance <= MfogStart) {
        return correctedColor;
    }

    float fogValue = vertexDistance < fogEnd ? smoothstep(MfogStart, fogEnd, vertexDistance) : 1.0;
    return vec4(mix(correctedColor.rgb, fogColor.rgb, fogValue * fogColor.a), inColor.a);
}

float linear_fog_fade(float vertexDistance, float fogStart, float fogEnd) {
    if (vertexDistance <= fogStart) {
        return 1.0;
    } else if (vertexDistance >= fogEnd) {
        return 0.0;
    }

    return smoothstep(fogEnd, fogStart, vertexDistance);
}

float fog_distance(vec3 pos, int shape) {
    if (shape == 0) {
        return length(pos);
    } else {
        float distXZ = length(pos.xz);
        float distY = abs(pos.y);
        return max(distXZ, distY);
    }
}
