// f1: initial value (x0)
float f1(float x) {
    return fract(sin(x * 17.1234) * 43758.5453);
}

// f2: amplitude [-1, 1]
float f2(float x) {
    return fract(sin(x * 78.233) * 24634.6345) * 2.0 - 1.0;
}

// f3: frequency (omega)
float f3(float x) {
    return fract(sin(x * 45.164) * 19491.3481) * 4.0 + 1.0; // [1,5] tránh omega quá bé
}
    
// Dao động tại một nút
float f4(float x, float t) {
    float x0 = f1(x);
    float A = f2(x);
    A = clamp(A, 0.2, 1.0); // tránh biên quá nhỏ
    float w = f3(x);
    float phi = asin(clamp(x0 / A, -1.0, 1.0));
    return A * sin(w * t + phi);
}
    
// Fade
float fade(float x) {
    return x * x * (3.0 - 2.0 * x);
}
    
// Value Noise động
float valueNoise1D(float x, float t) {
    float i = floor(x);
    float f = fract(x);
    float v0 = f4(i, t);
    float v1 = f4(i + 1.0, t);
    return mix(v0, v1, fade(f));
}
    
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    float x = uv.x * 10.0; // scale x-axis
    float yValue = valueNoise1D(x, iTime);

    // scale yValue [-1,1] → [0,1]
    float yPlot = yValue * 0.5 + 0.5;

    // Tính khoảng cách từ y pixel đến đường plot
    float dist = abs(uv.y - yPlot);

    // Nếu gần, thì làm sáng pixel
    float line = smoothstep(0.01, 0.001, dist); // càng nhỏ càng mảnh

    fragColor = vec4(vec3(line), 1.0);
}
