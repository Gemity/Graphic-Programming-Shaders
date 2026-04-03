// GLSL shader Voronoi cơ bản

// Hàm tạo số ngẫu nhiên vec2 từ vec2
vec2 rand2(vec2 p) 
{
    // Random direction inside cell
    float angle = fract(sin(dot(p, vec2(27.1, 61.7))) * 43758.5453) * 6.2831;
    return vec2(cos(angle), sin(angle)) * 0.5 + 0.5;
}

float voronoi(vec2 uv)
{
    // Scale lưới
    uv *= 10.0;
    
    // Tách chỉ số ô và phần dư
    vec2 i_uv = floor(uv);
    vec2 f_st = fract(uv);
    
    float minDist = 10.0;

    // Duyệt các ô lân cận
    for (int y = -1; y <= 1; y++) 
    {
        for (int x = -1; x <= 1; x++) 
        {
            vec2 offset = vec2(float(x), float(y));
            vec2 neighborCell = i_uv + offset;

            // Lấy vị trí hạt nhân trong ô (tạo động theo thời gian nếu muốn)
            vec2 point = rand2(neighborCell); // [0,1]
            
            // Nếu muốn nhân chuyển động, có thể thêm:
            // point += 0.3 * sin(iTime + 12.9898 * point);

            vec2 diff = offset + point - f_st;
            float dist = length(diff);

            minDist = min(minDist, dist);
        }
    }
    
    return minDist;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) 
{
    // Chuyển về uv [0,1]
    vec2 uv = fragCoord.xy / iResolution.xy;
		float v = voronoi(uv);

    // Hiển thị khoảng cách như màu xám
    fragColor = vec4(vec3(v), 1.0);
}