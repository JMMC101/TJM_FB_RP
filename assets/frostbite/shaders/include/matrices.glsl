#version 150

mat3 rotateX(float theta) {
    float tsin = sin(theta);
    float tcos = cos(theta);
    return mat3(
        1.0, 0.0, 0.0,
        0.0, tcos, -tsin,
        0.0, tsin, tcos
    );
}

mat3 rotateY(float theta) {
    float tsin = sin(theta);
    float tcos = cos(theta);
    return mat3(
        tcos, 0.0, tsin,
        0.0, 1.0, 0.0,
        -tsin, 0.0, tcos
    );
}

mat3 rotateZ(float theta) {
    float tsin = sin(theta);
    float tcos = cos(theta);
    return mat3(
        tcos, -tsin, 0.0,
        tsin, tcos, 0.0,
        0.0, 0.0, 1.0
    );
}