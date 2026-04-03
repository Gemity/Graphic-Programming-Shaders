// rand2: sinh vector hướng ngẫu nhiên từ điểm lưới
vec2 rand2(vec2 p) {
    float angle = fract(sin(dot(p, vec2(0.370,0.390))) * 43758.5453) * 6.2831;
    return vec2(cos(angle), sin(angle));
}

vec2 fade2(vec2 t) {
    return t * t * (3.0 - 2.0 * t);
}

float gradientNoise(vec2 p) {
    // i: integer cell, f: fractional
    vec2 i = floor(p);
    vec2 f = fract(p);

    // Gradient vectors (hash to get pseudo-random directions)
    vec2 g00 = rand2(i);
    vec2 g10 = rand2(i + vec2(1.0, 0.0));
    vec2 g01 = rand2(i + vec2(0.0, 1.0));
    vec2 g11 = rand2(i + vec2(1.0, 1.0));

    // Vectors from corner to p
    vec2 d00 = f - vec2(0.0, 0.0);
    vec2 d10 = f - vec2(1.0, 0.0);
    vec2 d01 = f - vec2(0.0, 1.0);
    vec2 d11 = f - vec2(1.0, 1.0);

    // Dot products
    float a = dot(g00, d00);
    float b = dot(g10, d10);
    float c = dot(g01, d01);
    float d = dot(g11, d11);

    // Fade & interpolate
    vec2 u = fade2(f);
    return mix(mix(a, b, u.x),
               mix(c, d, u.x), u.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 p = uv * 10.0; // scale field

    // Vector noise result
    float v = gradientNoise(p);
    v = 0.5 + v * 2.;

    fragColor = vec4(vec3(v), 1.0);
}