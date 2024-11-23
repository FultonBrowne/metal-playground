import SwiftUI

struct ContentView: View {
    // Remove mousePosition state variable
    // @State private var mousePosition = CGPoint(x: 0.5, y: 0.5)
    @State private var isButtonPressed = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // MetalView without mousePosition binding
                MetalView(isButtonPressed: $isButtonPressed)
                    .edgesIgnoringSafeArea(.all)
                    .removeTitleBar()

                // Remove the transparent layer capturing mouse movements
                // ...

                // Overlay UI elements
                VStack {
                    Spacer()

                    Text("Animated Metal Shader")
                        .font(.headline)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)

                    Spacer()

                    HStack {
                        Button("Toggle Effect") {
                            isButtonPressed.toggle()
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)

                        // Remove mouse position display
                        // Text("Mouse Position: \(String(format: "%.2f", mousePosition.x)), \(String(format: "%.2f", mousePosition.y))")
                        //     .padding()
                        //     .background(Color.black.opacity(0.5))
                        //     .cornerRadius(8)
                    }
                    .padding()

                    Spacer()
                }
                .padding(.top, 28) // Adjust padding as needed
            }
        }
    }
}

#Preview {
    ContentView()
}
