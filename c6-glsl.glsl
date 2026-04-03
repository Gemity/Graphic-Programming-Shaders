// rand2: random unit direction from lattice point
vec2 rand2(vec2 p) {
    float angle = fract(sin(dot(p, vec2(0.370,0.390))) * 43758.5453) * 6.2831;
    return vec2(cos(angle), sin(angle));
}

float fade(float t) {
    return t * t * (3.0 - 2.0 * t);
}

vec2 gradient(vec2 p, float t) {
    vec2 x0 = rand2(p);
    vec2 r  = rand2(p + vec2(4136.1254, 57449.6545));
    float angle = (r.x * 2.0 + 0.5) * t + r.y * 246.2831;
    mat2 rot = mat2(cos(angle), -sin(angle),
                    sin(angle),  cos(angle));
    return rot * x0;
}

float gradDot(vec2 p, vec2 delta, float t) {
    return dot(gradient(p, t), delta);
}

float gradientNoise2D(vec2 uv, float t) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    float v00 = gradDot(i + vec2(0.0, 0.0), f - vec2(0.0, 0.0), t);
    float v10 = gradDot(i + vec2(1.0, 0.0), f - vec2(1.0, 0.0), t);
    float v01 = gradDot(i + vec2(0.0, 1.0), f - vec2(0.0, 1.0), t);
    float v11 = gradDot(i + vec2(1.0, 1.0), f - vec2(1.0, 1.0), t);
    vec2 w = vec2(fade(f.x), fade(f.y));
    return mix(mix(v00, v10, w.x), mix(v01, v11, w.x), w.y);
}

// Dùng #define thay vì tham số — WebGL 1.0 yêu cầu loop bound là compile-time constant
#define OCTAVES 4

float fbm(vec2 uv, float t, float lacunarity, float gain) {
    float sum  = 0.0;
    float amp  = 1.0;
    float freq = 1.0;
    for (int o = 0; o < OCTAVES; o++) {
        sum  += gradientNoise2D(uv * freq, t * freq) * amp;
        freq *= lacunarity;
        amp  *= gain;
    }
    return sum;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy * 10.0;
    float t = iTime;

    float v = fbm(uv, t, 2.0, 0.5);
    v = v * 0.5 + 0.5;
    fragColor = vec4(vec3(v), 1.0);
}