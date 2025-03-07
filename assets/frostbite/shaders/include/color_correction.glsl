#version 330

#moj_import<frostbite:easing.glsl>

vec4 saturate(vec3 color) {
    float min_channel = min(min(color.r, color.g), color.b);
    float max_channel = max(max(color.r, color.g), color.b);

    color -= vec3(min_channel);
    color /= vec3(max_channel-min_channel);

    return vec4(color, min((max_channel-min_channel)/max_channel, 1.0));
}

float get_saturation(vec3 color) {
    float min_channel = min(min(color.r, color.g), color.b);
    float max_channel = max(max(color.r, color.g), color.b);

    return min((max_channel-min_channel)/max_channel, 1.0);
}

vec3 color_correct(vec3 color) {


    float luminocity = color.r * 0.299 + color.g * 0.587 + color.b * 0.114;
    vec3 grayscale = vec3(luminocity);

    vec4 oversaturated = saturate(color);
    //float saturation = get_saturation(color);
    //return vec3(oversaturated);
    //return vec3(dot(color/luminocity, oversaturated.rgb));

    vec3 invcolor = vec3(1.0) - color;
    vec3 red = mix(
        vec3(1.0, 0.2, 0.0),
        vec3(0.9, 0.0, 0.8),
        invcolor.r*invcolor.r
    ) * color.r;
    vec3 green = mix(
        vec3(0.0, 0.8, 0.4),
        vec3(0.0, 0.1, 0.9),
        invcolor.b*invcolor.b
    ) * color.g;
    vec3 blue = mix(
        vec3(0.5, 0.1, 0.9),
        vec3(0.9, 0.0, 0.9),
        invcolor.b*invcolor.b
    ) * color.b;

    vec3 colormod = red   * oversaturated.r
                  + green * oversaturated.g
                  + blue  * oversaturated.b;

    //color = mix(color, red, oversaturated.r);
    //color = mix(color, green, oversaturated.g);
    //color = mix(color, blue, oversaturated.b);

    return mix(color, colormod, oversaturated.a*oversaturated.a);


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