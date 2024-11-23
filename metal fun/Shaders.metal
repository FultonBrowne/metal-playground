#include <metal_stdlib>
using namespace metal;

constant float pi = 3.14159265;

struct VertexOut {
    float4 position [[ position ]];
};

vertex VertexOut vertexShader(uint vertexID [[ vertex_id ]]) {
    float2 positions[6] = {
        float2(-1.0, -1.0), float2(1.0, -1.0), float2(-1.0, 1.0),
        float2(-1.0, 1.0), float2(1.0, -1.0), float2(1.0, 1.0)
    };

    VertexOut out;
    out.position = float4(positions[vertexID], 0.0, 1.0);
    return out;
}

fragment float4 animatedGradientShader(VertexOut in [[ stage_in ]],
                                       constant float &buttonState [[ buffer(0) ]],
                                       constant float &time [[ buffer(1) ]]) {
    float2 uv = (in.position.xy + 1.0) / 2.0;

    // Create a more complex animation pattern
    float wave1 = sin((uv.x * 10.0) + time * 2.0);
    float wave2 = cos((uv.y * 10.0) + time * 2.0);
    float wave = wave1 * wave2;

    float r = 0.5 + 0.5 * wave;
    float g = uv.y;
    float b = 0.5 + 0.5 * cos(time * 2.0);

    if (buttonState > 0.5) {
        // Alternate effect
        r = uv.x;
        g = 0.5 + 0.5 * sin(time * 2.0);
        b = 0.5 + 0.5 * wave;
    }

    return float4(r, g, b, 1.0);
}
