#version 150

#define FOG_START_SCALER 0.15
#define FOG_END_SCALER   1.15
vec4 linear_fog(vec4 inColor, float vertexDistance, float fogStart, float fogEnd, vec4 fogColor) {
    float m_fogStart = fogStart * FOG_START_SCALER;
    float m_fogEnd   = fogEnd   * FOG_END_SCALER;
    if (vertexDistance <= m_fogStart) {
        return inColor;
    }

    float fogValue = vertexDistance < m_fogEnd ? smoothstep(m_fogStart, m_fogEnd, vertexDistance) : 1.0;
    return vec4(mix(inColor.rgb, fogColor.rgb, fogValue * fogColor.a), inColor.a);
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
    return length(pos);
}
