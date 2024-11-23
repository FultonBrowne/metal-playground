import SwiftUI

struct WindowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                WindowAccessor { window in
                    guard let window = window else { return }

                    // Hide the window title and make the title bar transparent
                    window.titleVisibility = .hidden
                    window.titlebarAppearsTransparent = true

                    // Ensure the content fills the entire window, including the title bar area
                    window.styleMask.insert(.fullSizeContentView)

                    // Allow the window to be moved by clicking and dragging the background
                    window.isMovableByWindowBackground = true

                    // Remove the toolbar if present
                    window.toolbar = nil

                    // Adjust the content view's superview to remove padding for the title bar
                    if let contentView = window.contentView,
                       let superview = contentView.superview {
                        superview.frame = window.frame
                        superview.translatesAutoresizingMaskIntoConstraints = true
                    }
                }
            )
    }
}

struct WindowAccessor: NSViewRepresentable {
    var callback: (NSWindow?) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.callback(view.window)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

extension View {
    func removeTitleBar() -> some View {
        self.modifier(WindowModifier())
    }
}
