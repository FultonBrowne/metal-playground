import SwiftUI
import Metal
import MetalKit

struct MetalView: NSViewRepresentable {
    // Remove mousePosition binding
    // @Binding var mousePosition: CGPoint
    @Binding var isButtonPressed: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(isButtonPressed: $isButtonPressed)
    }

    func makeNSView(context: Context) -> MTKView {
        let metalView = MTKView()
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.delegate = context.coordinator
        metalView.enableSetNeedsDisplay = false // Continuous rendering
        metalView.isPaused = false
        metalView.preferredFramesPerSecond = 60
        return metalView
    }

    func updateNSView(_ nsView: MTKView, context: Context) {
        // Handle updates if necessary
    }

    class Coordinator: NSObject, MTKViewDelegate {
        var device: MTLDevice!
        var pipelineState: MTLRenderPipelineState!
        var commandQueue: MTLCommandQueue!
        var time: Float = 0.0

        // Remove mousePosition binding
        // @Binding var mousePosition: CGPoint
        @Binding var isButtonPressed: Bool

        // Updated initializer
        init(isButtonPressed: Binding<Bool>) {
            _isButtonPressed = isButtonPressed
            super.init()

            device = MTLCreateSystemDefaultDevice()
            commandQueue = device.makeCommandQueue()
            setupPipeline()
        }

        func setupPipeline() {
            let library = device.makeDefaultLibrary()
            let vertexFunction = library?.makeFunction(name: "vertexShader")
            let fragmentFunction = library?.makeFunction(name: "animatedGradientShader") // Ensure this matches your shader function

            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = vertexFunction
            pipelineDescriptor.fragmentFunction = fragmentFunction
            pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

            pipelineState = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            // Handle resizing if necessary
        }

        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let renderPassDescriptor = view.currentRenderPassDescriptor else { return }

            let commandBuffer = commandQueue.makeCommandBuffer()
            let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            renderEncoder?.setRenderPipelineState(pipelineState)

            // Update time
            time += 1.0 / Float(view.preferredFramesPerSecond)

            // Pass button state and time to the shader
            var buttonState = isButtonPressed ? 1.0 : 0.0
            var currentTime = time

            // Update buffer indices accordingly
            renderEncoder?.setFragmentBytes(&buttonState, length: MemoryLayout<Float>.size, index: 0)
            renderEncoder?.setFragmentBytes(&currentTime, length: MemoryLayout<Float>.size, index: 1)

            renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
            renderEncoder?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
    }
}
