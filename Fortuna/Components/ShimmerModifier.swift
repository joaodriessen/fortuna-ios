import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content.overlay(
            LinearGradient(
                colors: [.clear, .white.opacity(0.3), .clear],
                startPoint: UnitPoint(x: phase - 0.3, y: 0),
                endPoint: UnitPoint(x: phase, y: 1)
            )
            .allowsHitTesting(false)
        )
        .onAppear {
            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                phase = 1.3
            }
        }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
