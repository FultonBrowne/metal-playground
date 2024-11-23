import SwiftUI
import Metal
import MetalKit

// MetalView: A bridge to integrate Metal rendering into SwiftUI
struct MetalView: NSViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> MTKView {
        // Create a MetalKit view (MTKView) to display Metal content
        let metalView = MTKView()
        metalView.device = MTLCreateSystemDefaultDevice() // Use the default GPU
        metalView.delegate = context.coordinator          // Set the coordinator as the delegate
        metalView.enableSetNeedsDisplay = true            // Allow manual control of rendering
        return metalView
    }

    func updateNSView(_ nsView: MTKView, context: Context) {
        // Any updates from SwiftUI can be handled here
    }

    // Coordinator handles Metal rendering
    class Coordinator: NSObject, MTKViewDelegate {
        var device: MTLDevice!                      // GPU device
        var pipelineState: MTLRenderPipelineState!  // Render pipeline state
        var commandQueue: MTLCommandQueue!          // Command queue for rendering

        override init() {
            super.init()
            device = MTLCreateSystemDefaultDevice()       // Initialize GPU
            commandQueue = device.makeCommandQueue()      // Create a command queue
            setupPipeline()                               // Setup render pipeline
        }

        func setupPipeline() {
            // Load the Metal shader from the project bundle
            let library = device.makeDefaultLibrary()
            let vertexFunction = library?.makeFunction(name: "vertexShader")
            let fragmentFunction = library?.makeFunction(name: "gradientShader")

            // Configure the pipeline descriptor
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = vertexFunction
            pipelineDescriptor.fragmentFunction = fragmentFunction
            pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

            // Create the pipeline state object
            pipelineState = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            // Handle resizing if needed
        }

        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let renderPassDescriptor = view.currentRenderPassDescriptor else {
                return
            }

            // Begin a render pass
            let commandBuffer = commandQueue.makeCommandBuffer()
            let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            renderEncoder?.setRenderPipelineState(pipelineState) // Set the pipeline state

            // Draw a full-screen quad (2D rectangle)
            renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)

            renderEncoder?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
    }
}