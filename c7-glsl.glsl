in vec2 vUV; // truyền từ vertex shader
out vec4 fragColor;

uniform sampler2D _HeightMap;
uniform vec2  _TexelSize;   // (1/width, 1/height)
uniform float _HeightScale;

float sampleHeight(vec2 uv) {
    return texture(_HeightMap, uv).r;
}

void main() {
    vec2 uv = vUV;
    float dx = _TexelSize.x;
    float dy = _TexelSize.y;

    // Sample neighboring pixels
    float hL = sampleHeight(uv + vec2(-dx, 0.0));
    float hR = sampleHeight(uv + vec2( dx, 0.0));
    float hD = sampleHeight(uv + vec2(0.0, -dy));
    float hU = sampleHeight(uv + vec2(0.0,  dy));

    float sx = (hR - hL) * _HeightScale;
    float sy = (hU - hD) * _HeightScale;

    vec3 normal = normalize(vec3(-sx, -sy, 1.0));
    normal = normal * 0.5 + 0.5;

    fragColor = vec4(normal, 1.0);
}