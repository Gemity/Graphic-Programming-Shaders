// Hàm hash đơn giản từ tọa độ 2D
float rand(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
// Hàm fade cubic (Perlin-style)
vec2 fade(vec2 t) {
    return t * t * (3.0 - 2.0 * t);
}

// Value Noise 2D
float valueNoise(vec2 p) {

// Lấy phần nguyên và thập phân
    vec2 i = floor(p);
    vec2 f = fract(p);

// Lấy giá trị random tại 4 góc
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    
// Làm mượt hệ số nội suy
    vec2 u = fade(f);
    
// Bilinear interpolation
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;

    float scale = 10.0;
    float noise = valueNoise(uv * scale);

    fragColor = vec4(vec3(noise), 1.0);
}