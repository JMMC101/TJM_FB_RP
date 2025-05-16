#version 330

#moj_import <frostbite:easing.glsl>
#moj_import <frostbite:waves.glsl>


uniform float AmbientLightFactor;
uniform float SkyFactor;
uniform float BlockFactor;
uniform int UseBrightLightmap;
uniform vec3 SkyLightColor;
uniform float NightVisionFactor;
uniform float DarknessScale;
uniform float DarkenWorldFactor;
uniform float GameTime;

uniform float BrightnessFactor;

in vec2 texCoord;

out vec4 fragColor;

float get_brightness(float level) {
    float curved_level = level / (4.0 - 3.0 * level);
    return mix(curved_level, 1.0, AmbientLightFactor);
}

vec3 notGamma(vec3 x) {
    vec3 nx = 1.0 - x;
    return 1.0 - nx * nx * nx * nx;
}

#define MOONLIGHT_COLOR vec3(0.04, 0.02, 0.06)
#define SUNLIGHT_COLOR  vec3(1.0, 1.0, 0.9)
#define SUNSET_COLOR    vec3(1.2, 0.9, 0.3)

#define BLOCK_LIGHT_COLOR vec3(1.0, 0.9, 0.4)

void main() {
    vec3 color;
    //color = vec3(texCoord, 0.5);

    //color = vec3(SkyFactor, BlockFactor, 0.5);

    //float factor = SkyFactor;
    //float factor = texCoord.y;
    float factor = texCoord.x;

    // don't ask
    float sunsetness = 1.0 - abs(SkyFactor*2-1.0);
    sunsetness *= sunsetness;
    sunsetness *= sunsetness;
    sunsetness *= sunsetness;
    sunsetness = 1.0-sunsetness;
    sunsetness *= sunsetness;
    sunsetness *= sunsetness;
    sunsetness *= sunsetness;
    sunsetness = 1.0-sunsetness;

    float daynight_factor = max(SkyFactor-0.25, 0.0)*1.3333;

    //color = vec3(sunsetness);
    vec3 skylight_color = mix(MOONLIGHT_COLOR, SUNLIGHT_COLOR, cubic_in_out(daynight_factor));
    vec3 sunset_color = vec3(
        skylight_color.r*1.4, 
        skylight_color.g*skylight_color.g*1.4, 
        skylight_color.b*skylight_color.b*skylight_color.b
    );
    skylight_color = mix(skylight_color, sunset_color, sunsetness*0.4);

    //vec3 block_light = vec3(factor, half_square(factor), factor*factor);
    //vec3 block_light = mix(
    //    vec3(half_square(factor), factor*factor, factor*factor*factor),
    //    BLOCK_LIGHT_COLOR*factor*factor,
    //    factor
    //)*factor;
    //(1.0-factor)*0.5

    float block_light_jitter = 
        -0.125 + (
            triangular_wave(GameTime*244.0)*0.3125
            + triangular_wave(GameTime*43454.678)*0.125
            + triangular_wave(GameTime*700.23)*0.25
            + triangular_wave(GameTime*323.234)*0.3125
        ) * 0.5;

    float factor2 = any_square(texCoord.x*texCoord.x, block_light_jitter);
    float factor4 = factor2*factor2;
    float factor8 = factor4*factor4;

    vec3 block_light = vec3(factor2, minor_square(factor2), half_square(factor2)*0.7);

    block_light = min(
        block_light + vec3(factor8*factor8*0.3),
        vec3(1.0)
    );

    block_light = mix(
        block_light,
        vec3(0.9, 0.7, 0.0)*factor4,
        texCoord.y*daynight_factor
    );

    float darkening = DarknessScale < 0.01 
        ? 1.0
        : pow(max(texCoord.x, texCoord.y), DarknessScale*5.0);

    fragColor = vec4((block_light+skylight_color*texCoord.y + vec3(NightVisionFactor*0.3))*darkening, 1.0);
    //fragColor = mix(fragColor, vec4(1.0), 0.33);
    //fragColor = vec4(vec3(pow(texCoord.x, block_light_jitter)), 1.0);
}
///effect give @s minecraft:night_vision 32
//effect give @s minecraft:night_vision 32