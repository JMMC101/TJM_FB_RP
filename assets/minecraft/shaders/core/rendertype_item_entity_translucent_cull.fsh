#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <frostbite:easing.glsl>
#moj_import <frostbite:matrices.glsl>
#moj_import <frostbite:noise.glsl>

#define halfpi 1.5707963267948966
#define pi 3.141592653589793
#define tau 6.283185307179586

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

in vec3 world_pos;

in vec3 pos_xz_0;
in vec3 pos_xz_1;
in vec3 pos_xz_2;
in vec2 moon_center_uv;

flat in int object_type;

out vec4 fragColor;

float non_asin(float x) {
    float y = x*x*x;
    return x + y*y*0.5;
}

float isctz(float x) { return abs(x) < 1e-10 ? 1.0 : 0.0; }
float isz(float x) { return x == 0.0 ? 1.0 : 0.0; }

vec2 get_recived_size() {
    vec2 corner0 = pos_xz_0.xy / pos_xz_0.z;
    vec2 corner1 = pos_xz_1.xy / pos_xz_1.z;
    vec2 corner2 = pos_xz_2.xy / pos_xz_2.z;
    
    vec2 min_cor = min(min(corner0, corner1), corner2);
    vec2 max_cor = max(max(corner0, corner1), corner2);

    return max_cor - min_cor;
}

vec3 plane_intersect(float dist, vec3 dir) {
    float t = dist / dir.y;
    return dir * t;
}

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
        gl_FragDepth = 0.9999;
        //mat2 a = mat2(1.0);
        //mat4 b = mat4(a);
        //fragColor = vec4(vec3(b[2][2]), 1.0); return;
        //fragColor = vec4(fract(texCoord0* 8.0), 0.0, 1.0); return;
        //fragColor = vec4(fract(moon_center_uv* 1024.35466), 0.0, 1.0); return;
        //fragColor = vec4(moon_center_uv, 0.0, 1.0); return;
        vec3 color_stars = texture(Sampler0, texCoord0).rgb;
        //if (color_stars.g - (color_stars.r + color_stars.b) > 0.5) {
        //    fragColor = vec4(1.0);
        //    return;
        //}

        vec2 recived_size = get_recived_size();
        float recived_data = max(recived_size.x, recived_size.y);
        //fragColor = vec4(color0 + vec3(recived_size, height), 1.0);

        vec3 normalized_world_pos = normalize(world_pos);

        float breakup = mod(gl_FragCoord.y, 3.0) * 0.02;

        float mod_heightF = abs(normalized_world_pos.y + 0.2);
        mod_heightF *= mod_heightF;
        mod_heightF = 1.0 - mod_heightF;
        mod_heightF *= mod_heightF;
        mod_heightF *= mod_heightF + breakup;
        color_stars += vec3(0.2, 0.18, 0.3) * mod_heightF * 0.1;
        mod_heightF *= mod_heightF;
        color_stars += vec3(0.31, 0.23, 0.3) * mod_heightF * 0.1;


        float mod_heightA = cubic_in_out(clamp((normalized_world_pos.y - 0.05) * 3.0, 0.0, 1.0));
        float mod_heightB = 1.0 - max(normalized_world_pos.y + 0.1, 0.0);
        mod_heightB *= mod_heightB;
        mod_heightB *= mod_heightB;  float mod_heightE = mod_heightB;  // to avoid repeatimg the same computations
        mod_heightB *= mod_heightB;

        vec3 sky_color1 = mix(
            vec3(0.6, 0.6, 1.0),
            vec3(0.6, 0.53, 0.85),
            mod_heightA
        ) + vec3(
            mod_heightB * 0.2,
            mod_heightB*mod_heightB * 0.2,
            0.0
        );

        vec3 moon_light_color = mix(
            vec3(1.0, 1.0, 1.0),
            vec3(1.0, 1.0, 0.0),
            mod_heightE
        );
        mod_heightE *= mod_heightE;
        moon_light_color = mix(
            moon_light_color,
            vec3(1.0, 0.5, 0.2),
            mod_heightE
        );
        //fragColor = vec4(moon_light_color, 1.0); return;

        vec3 rotated_normalized_world_pos = rotateZ(recived_data) * normalized_world_pos;


        float sun_area_factor = max(rotated_normalized_world_pos.y,0.0);
        float moon_area_factor = max(-rotated_normalized_world_pos.y,0.0);

        vec3 plane_intersection = plane_intersect(1.0, rotated_normalized_world_pos);
        float celestial_body_dist = max(abs(plane_intersection.x), abs(plane_intersection.z));

        float sun = clamp(floor((0.1-celestial_body_dist)*48.0)/2.2 * sun_area_factor, 0.0,1.0);

        vec4 moon = texture(Sampler0, plane_intersection.zx / textureSize(Sampler0,0).xy * 64.0 + moon_center_uv);
        //moon = vec4(
        //    clamp(floor((0.1-celestial_body_dist)*48.0) * moon_area_factor, 0.0,1.0)
        //);
        moon *= moon.a * clamp((0.1-celestial_body_dist)*48.0 * moon_area_factor, 0.0,1.0);
        moon_area_factor = min(non_asin(clamp(moon_area_factor, -1.0, 1.0)) / 1.57, 1.0);
        moon_area_factor *= moon_area_factor;
        moon_area_factor *= moon_area_factor;
        moon_area_factor *= moon_area_factor;
        moon_area_factor = moon_area_factor*0.3 + moon_area_factor*moon_area_factor*moon_area_factor*0.4;
        moon.rgb += vec3(moon_area_factor * (1.0 - moon.a));
        moon.rgb *= moon_light_color;

        color_stars.rgb *= (1.0 - moon.a);

        //color_stars.rgb *= (1.0 - moon.a);  // makes the moon block stars


        //fragColor = vec4(vec3(1.0), sun); return;

        
        //fragColor = vec4(plane_intersection / 100.0, 1.0); return;  // sick ahh ting lol
        //fragColor = vec4(vec3(min(plane_intersection.x, plane_intersection.z)) / 10.0, 1.0); return;  //wtf it's so cool
        //fragColor = vec4(vec3() / 10.0, 1.0); return;

        //vec3 color2 = mix(color0, color1, recived_data);

        float glow = pow(max(rotated_normalized_world_pos.y, 0.0), 16.0) * sun_area_factor;
        //fragColor = vec4(
        //    vec3( dot(rotated_normalized_world_pos, vec3(0.0, 1.0, 0.0)) ),
        //    1.0
        //); return;

        
        float daynight_factor = clamp(
                                eight_sixteen_in_out(cos(recived_data) * 0.5 + 0.5) 
                                + rotated_normalized_world_pos.y*rotated_normalized_world_pos.y*rotated_normalized_world_pos.y*0.2
                                + min(normalized_world_pos.y, 0.0), 0.0,1.0
                            );
        float sunsetrise_factor = max(-cos(recived_data * 2.0), 0.0);
        //float sunset_mix_factor = clamp(abs(fract(recived_data / tau) * 2.0 - 1.0) * 500.0 - 249.0, 0.0, 1.0);
        float sunset_mix_factor = abs(fract(recived_data / tau) * 2.0 - 1.0) * 500.0 - 249.0;
        if (sunset_mix_factor > 0.999) {
            sunsetrise_factor *= sunsetrise_factor;
            sunsetrise_factor *= sunsetrise_factor;
            sunsetrise_factor *= sunsetrise_factor;
            sunsetrise_factor *= sunsetrise_factor;
        }
        
        //fragColor = vec4(vec3(daynight_factor, sun, 0.0), 1.0); return;
        //0.939202


        float mod_heightC = 1.0 - max(normalized_world_pos.y, 0.0);
        float mod_heightD =  max(1.0 - max(normalized_world_pos.y*1.6 + 0.25, 0.0), 0.0);
        //fragColor = vec4(vec3(mod_heightD), 1.0); return;

        vec3 col_1 = mix(
            sky_color1,
            mix(
                vec3(0.6, 0.5, 0.6),
                //vec3(1.0, 0.6, 0.0),
                vec3(1.0, 0.6, 0.7),
                mod_heightC
            ),
            sunsetrise_factor
        );

        sunsetrise_factor *= sunsetrise_factor;

        vec3 col0 = mix(
            col_1,
            vec3(1.0, 1.0, 0.5),
            mod_heightC * sunsetrise_factor * (0.55 + rotated_normalized_world_pos.y*0.5)
        );
        sunsetrise_factor = half_square(sunsetrise_factor);
        vec3 col1 = mix(
            col0,
            vec3(1.0, 0.6, 0.3),
            pow(mod_heightC, 4.0) * sunsetrise_factor * (0.45 + rotated_normalized_world_pos.y*0.55)
        );
        //vec3 col2 = mix(
        //    col1,
        //    vec3(0.6, 0.1, 0.0),
        //    pow(mod_heightC, 32.0) * sunsetrise_factor * (0.45 + rotated_normalized_world_pos.y*0.55)
        //);
        vec3 col2 = mix(
            col1,
            vec3(0.6, 0.1, 0.0),
            pow(mod_heightD, 8.0) * sunsetrise_factor * (0.9 + rotated_normalized_world_pos.y*0.1)
        );







        //fragColor = vec4(float(int(gl_FragCoord.x) & 3)/4.0, 0.0, 0.0, 1.0); return;

        bool reference = (int(gl_FragCoord.y) & 7) == 0;

        vec4 final_test_color = vec4(
            mix(color_stars, col2, daynight_factor)
            + vec3(glow*0.3, glow*glow*0.4, glow*0.1)
            + vec3(sun, sun*sun, sun*0.3)
            + moon.rgb,
            1.0
        );

        switch (int(gl_FragCoord.x) & 7) {

            // RED MARKER
            case 0:
            if (reference) { fragColor = vec4(1.0,0.0,0.0,1.0); break; }
            fragColor = vec4(
                isz(glow),
                -sign(glow),
                isnan(glow),
                1.0
            ); break;

            // GREEN MARKER
            case 1:
            if (reference) { fragColor = vec4(0.0,1.0,0.0,1.0); break; }
            fragColor = vec4(
                isz(rotated_normalized_world_pos.y),
                -sign(rotated_normalized_world_pos.y),
                isnan(rotated_normalized_world_pos.y),
                1.0
            ); break;

            // BLUE MARKER
            case 2:
            if (reference) { fragColor = vec4(0.0,0.0,1.0,1.0); break; }
            fragColor = vec4(
                isnan(color_stars.b),
                isnan(mod_heightC * sunsetrise_factor * (0.55 + rotated_normalized_world_pos.y*0.5)),
                isnan(final_test_color.b),
                1.0
            ); break;

            // GRAY MARKER
            case 3:
            if (reference) { fragColor = vec4(0.5,0.5,0.5,1.0); break; }
            fragColor = vec4(
                isnan(pow(-0.3243, 8.0)),
                isnan(0.0*1e1000000),
                isnan(asin(-23.34354)),
                1.0
            ); break;

            // MAGENTA MARKER
            case 4:
            if (reference) { fragColor = vec4(1.0,0.0,1.0,1.0); break; }
            fragColor = vec4(
                log2(abs(mod_heightD)),
                -log2(abs(mod_heightD)),
                -mod_heightD,
                1.0
            ); break;

            // YELLOW MARKER
            case 5:
            if (reference) { fragColor = vec4(1.0,1.0,0.0,1.0); break; }
            fragColor = vec4(
                log2(abs(col1.b)) / 255.0,
                -log2(abs(col1.b)) / 255.0,
                isz(col1.b),
                1.0
            ); break;

            // CYAN MARKER
            case 6:
            if (reference) { fragColor = vec4(0.0,1.0,1.0,1.0); break; }
            fragColor = vec4(
                log2(abs(moon_area_factor)) / 255.0,
                -log2(abs(moon_area_factor)) / 255.0,
                isz(moon_area_factor),
                1.0
            ); break;

            case 7:
            fragColor = vec4(moon.rgb, 1.0); break;
        }
        return;

        //switch (int(gl_FragCoord.x) & 3) {
        //    case 0:
        //    if (reference) { fragColor = vec4(1.0,0.0,0.0,1.0); break; }
        //    fragColor = vec4(
        //        abs(final_test_color.r) < 1e-10 ? 1.0 : 0.0,
        //        -sign(final_test_color.r),
        //        isnan(final_test_color.r),
        //        1.0
        //    ); break;
//
        //    case 1:
        //    if (reference) { fragColor = vec4(0.0,1.0,0.0,1.0); break; }
        //    fragColor = vec4(
        //        abs(final_test_color.g) < 1e-10 ? 1.0 : 0.0,
        //        -sign(final_test_color.g),
        //        isnan(final_test_color.g),
        //        1.0
        //    ); break;
//
        //    case 2:
        //    if (reference) { fragColor = vec4(0.0,0.0,1.0,1.0); break; }
        //    fragColor = vec4(
        //        abs(final_test_color.b) < 1e-10 ? 1.0 : 0.0,
        //        -sign(final_test_color.b),
        //        isnan(final_test_color.b),
        //        1.0
        //    ); break;
//
        //    case 3:
        //    fragColor = vec4(vec3(0.0),1.0);
        //}
        //return;

        //switch (int(gl_FragCoord.x) & 3) {
        //    case 0:
        //    if (reference) { fragColor = vec4(1.0,0.0,0.0,1.0);break; }
        //    fragColor = vec4(
        //        sun_area_factor,
        //        moon_area_factor,
        //        celestial_body_dist,
        //        1.0
        //    ); break;
//
        //    case 1:
        //    if (reference) { fragColor = vec4(0.0,1.0,0.0,1.0);break; }
        //    fragColor = vec4(
        //        moon_area_factor,
        //        glow,
        //        daynight_factor,
        //        1.0
        //    ); break;
//
        //    case 2:
        //    if (reference) { fragColor = vec4(0.0,0.0,1.0,1.0);break; }
        //    fragColor = vec4(
        //        normalized_world_pos,
        //        1.0
        //    ); break;
//
        //    case 3:
        //    if (reference) { fragColor = vec4(1.0,0.0,1.0,1.0);break; }
        //    fragColor = vec4(
        //        plane_intersection,
        //        1.0
        //    ); break;
        //}; return;

        fragColor = vec4(
            mix(color_stars, col2, daynight_factor)
            + vec3(glow*0.3, glow*glow*0.4, glow*0.1)
            + vec3(sun, sun*sun, sun*0.3)
            + moon.rgb,
            1.0
        );

        break;

        case 8: break;
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

        //vec2 corner0 = pos_xz_0.xy / pos_xz_0.z;
        //vec2 corner1 = pos_xz_1.xy / pos_xz_1.z;
        //vec2 corner2 = pos_xz_2.xy / pos_xz_2.z;
//
        ////float minX = min(min(corner0.x, corner1.x), corner2.x);
        ////float minY = min(min(corner0.y, corner1.y), corner2.y);
        //vec2 min_cor = min(min(corner0, corner1), corner2);
        //vec2 max_cor = max(max(corner0, corner1), corner2);
        //
        //fragColor = vec4(
        //    //(corner0.x - corner1.x),
        //    //(corner1.y - corner2.y),
        //    max_cor - min_cor,
        //    //(pos_xz_2 - pos_xz_0) * 32.0,
        //    //(corner1 - corner2),
        //    0.0,
        //    1.0
        //);

        //fragColor = debug_color;
        //gl_FragDepth = gl_FragCoord.z;
        //break;
        //case 9:
        //fragColor = vec4(0.0, 1.0, 1.0, 1.0);
        //gl_FragDepth = gl_FragCoord.z;
        //break;
    }
}
