#version 330

//float noise(vec2 coords, float offset) {
//    float rand = mod(coords.x*246789.42421390728465687989 + coords.y*239896.435649635445 + 3.24354 + offset*36247396898.3753285734, 1.1463976);
//    rand = mod(coords.x*rand + coords.y*rand + 2.35884, 0.032493554657)*30.775385846400053545;
//    rand = mod(coords.x*rand + coords.y*rand + 5.3884161308205838942725165231435437, 0.001)*1000.0;
//
//    return rand;
//}


/*
    static.frag
    by Spatial
    05 July 2013
*/

#moj_import <frostbite:easing.glsl>

// A single iteration of Bob Jenkins' One-At-A-Time hashing algorithm.
uint hash( uint x ) {
    x += ( x << 10u );
    x ^= ( x >>  6u );
    x += ( x <<  3u );
    x ^= ( x >> 11u );
    x += ( x << 15u );
    return x;
}



// Compound versions of the hashing algorithm I whipped together.
uint hash( uvec2 v ) { return hash( v.x ^ hash(v.y)                         ); }
uint hash( uvec3 v ) { return hash( v.x ^ hash(v.y) ^ hash(v.z)             ); }
uint hash( uvec4 v ) { return hash( v.x ^ hash(v.y) ^ hash(v.z) ^ hash(v.w) ); }



// Construct a float with half-open range [0:1] using low 23 bits.
// All zeroes yields 0.0, all ones yields the next smallest representable value below 1.0.
float floatConstruct( uint m ) {
    const uint ieeeMantissa = 0x007FFFFFu; // binary32 mantissa bitmask
    const uint ieeeOne      = 0x3F800000u; // 1.0 in IEEE binary32

    m &= ieeeMantissa;                     // Keep only mantissa bits (fractional part)
    m |= ieeeOne;                          // Add fractional part to 1.0

    float  f = uintBitsToFloat( m );       // Range [1:2]
    return f - 1.0;                        // Range [0:1]
}



// this is all mine after that tho
float white_noise(float t) {
    uint ut = uint(t);
    return floatConstruct(
        hash(ut)
    );
}
float white_noise(uint ut) {
    return floatConstruct(
        hash(ut)
    );
}

float white_noise(vec2 vec) {
    uvec2 uvec = uvec2(vec);
    return floatConstruct(
        hash(uvec)
    );
}
float white_noise(uvec2 uvec) {
    return floatConstruct(
        hash(uvec)
    );
}

float white_noise(vec3 vec) {
    uvec3 uvec = uvec3(vec);
    return floatConstruct(
        hash(uvec)
    );
}
float white_noise(uvec3 uvec) {
    return floatConstruct(
        hash(uvec)
    );
}



float lerp(float first, float second, float t) {
    return first+(second-first)*t;
}
float perlin_noise(float t) {
    float fractional = cubic_in_out(fract(t));
    uint main = uint(t);
    vec2 v = vec2(
        white_noise(main),
        white_noise(main+1u)
    );
    return lerp(v.x, v.y, fractional);
}
float perlin_noise(vec2 vec) {
    vec2 fractional = cubic_in_out(fract(vec));
    uvec2 main = uvec2(vec);
    //values
    vec4 v = vec4(
        white_noise(uvec2(main.x, main.y)),
        white_noise(uvec2(main.x+1u, main.y)),
        white_noise(uvec2(main.x, main.y+1u)),
        white_noise(uvec2(main.x+1u, main.y+1u))
    );
    return(
        lerp(
            lerp(v.x, v.y, fractional.x),
            lerp(v.z, v.w, fractional.x),
            fractional.y
        )
    );
}
float perlin_noise(vec3 vec) {
    vec3 fractional = cubic_in_out(fract(vec));
    uvec3 main = uvec3(vec);
    //values
    vec4 v0 = vec4(
        white_noise(uvec3(main.x, main.y, main.z)),
        white_noise(uvec3(main.x+1u, main.y, main.z)),
        white_noise(uvec3(main.x, main.y+1u, main.z)),
        white_noise(uvec3(main.x+1u, main.y+1u, main.z))
    );
    vec4 v1 = vec4(
        white_noise(uvec3(main.x, main.y, main.z+1u)),
        white_noise(uvec3(main.x+1u, main.y, main.z+1u)),
        white_noise(uvec3(main.x, main.y+1u, main.z+1u)),
        white_noise(uvec3(main.x+1u, main.y+1u, main.z+1u))
    );
    // could it be better? probably yes.
    return(
        lerp(
            lerp(
                lerp(v0.x, v0.y, fractional.x),
                lerp(v0.z, v0.w, fractional.x),
                fractional.y
            ),
            lerp(
                lerp(v1.x, v1.y, fractional.x),
                lerp(v1.z, v1.w, fractional.x),
                fractional.y
            ),
            fractional.z
        )
    );
}