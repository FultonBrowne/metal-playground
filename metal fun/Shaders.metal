#include <metal_stdlib>
using namespace metal;

// Vertex shader: Defines the positions of the vertices
vertex float4 vertexShader(const device float2 *vertexArray [[ buffer(0) ]],
                           uint vertexID [[ vertex_id ]]) {
    // Simple quad positions (two triangles covering the full screen)
    float2 positions[6] = {
        float2(-1.0, -1.0), float2( 1.0, -1.0), float2(-1.0,  1.0),
        float2(-1.0,  1.0), float2( 1.0, -1.0), float2( 1.0,  1.0)
    };
    return float4(positions[vertexID], 0.0, 1.0); // Convert 2D positions to 4D (homogeneous coordinates)
}

// Fragment shader: Outputs the gradient color for each pixel
fragment float4 gradientShader(float4 fragCoord [[ position ]]) {
    // Normalize coordinates to [0, 1]
    float2 uv = fragCoord.xy / float2(800.0, 600.0); // Replace with dynamic screen size if needed
    return float4(uv.x, uv.y, 1.0 - uv.x, 1.0); // Generate gradient colors
}