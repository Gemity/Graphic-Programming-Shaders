// rand2: random unit direction from lattice point
vec2 rand2(vec2 p) {
    float angle = fract(sin(dot(p, vec2(0.370,0.390))) * 43758.5453) * 6.2831;
    return vec2(cos(angle), sin(angle));
}

// Perlin cubic fade
float fade(float t) {
    return t * t * (3.0 - 2.0 * t);
}

// Time-varying lattice gradient (unit length)
vec2 gradient(vec2 p, float t) {
    vec2 x0 = rand2(p);
    vec2 r  = rand2(p + vec2(4136.1254, 57449.6545)); // r.x: omega seed, r.y: phase seed
    float angle = (r.x * 2.0 + 0.5) * t + r.y * 246.2831;
    mat2 rot = mat2(cos(angle), -sin(angle),
                    sin(angle),  cos(angle));
    return rot * x0;
}

// Dot of gradient with local offset
float gradDot(vec2 p, vec2 delta, float t) {
    vec2 g = gradient(p, t);
    return dot(g, delta);
}

// Animated 2D Gradient Noise (raw in ~[-1,1])
float gradientNoise2D(vec2 uv, float t) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float v00 = gradDot(i + vec2(0.0, 0.0), f - vec2(0.0, 0.0), t);
    float v10 = gradDot(i + vec2(1.0, 0.0), f - vec2(1.0, 0.0), t);
    float v01 = gradDot(i + vec2(0.0, 1.0), f - vec2(0.0, 1.0), t);
    float v11 = gradDot(i + vec2(1.0, 1.0), f - vec2(1.0, 1.0), t);

    vec2 w = vec2(fade(f.x), fade(f.y));
    float x0 = mix(v00, v10, w.x);
    float x1 = mix(v01, v11, w.x);
    return mix(x0, x1, w.y);
}

// -------- fBm with per-octave time scaling --------
// lacunarity: frequency multiplier per octave (usually 2.0)
// gain: amplitude multiplier per octave (usually 0.5)
// octaves: number of layers
float fbm(vec2 uv, float t, int octaves, float lacunarity, float gain) {
    float sum    = 0.0;
    float amp    = 1.0;
    float freq   = 1.0;

    for (int o = 0; o < octaves; o++) {
        // Per-octave time scaling: higher freq -> faster motion
        float val = gradientNoise2D(uv * freq, t * freq);
        sum  += val * amp;
        freq *= lacunarity;
        amp  *= gain;
    }
    
    return sum;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy * 10.0;
    float t = iTime;

    // fBm params
    const int   OCTAVES    = 4;
    float       lacunarity = 2.0;   // doubles frequency each octave
    float       gain       = 0.5;   // halves amplitude each octave

    float v = fbm(uv, t, OCTAVES, lacunarity, gain); // ~[-1,1]
    v = v * 0.5 + 0.5;                               // map to [0,1]

    fragColor = vec4(vec3(v), 1.0);
}