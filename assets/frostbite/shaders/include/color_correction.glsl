#version 330

#moj_import<frostbite:easing.glsl>

vec3 color_correct(vec3 color) {
    float luminocity = color.r * 0.299 + color.g * 0.587 + color.b * 0.114;
    vec3 grayscale = vec3(luminocity);

    //float warmness = length(color/luminocity - vec3(1.0, 0.5, 0.0));
    float warmness = color.r - max(color.g*0.6, color.b);
    //return vec3(warmness);

    vec3 col0 = mix(
        vec3(0.3, 0.0, 1.0),
        //vec3(1.0, 0.6, 0.0),
        vec3(0.6, 0.55, 0.3),
        luminocity
    );
    vec3 col1 = mix(
        vec3(0.5),
        col0,
        cubic_in_out(abs(luminocity-0.5)*2.0)
    ) * luminocity + vec3(luminocity/2.0);
    

    return mix(col1, color, 0.6 + warmness*0.5);
}