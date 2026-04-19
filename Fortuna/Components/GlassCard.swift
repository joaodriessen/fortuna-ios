import SwiftUI

// Legacy alias kept for any views still using it
// New code should call .fortGlass() directly
struct FortunaCard<Content: View>: View {
    var padding: CGFloat = 20
    var cornerRadius: CGFloat = 24
    var tint: Color = .clear
    let content: () -> Content

    init(
        padding: CGFloat = 20,
        cornerRadius: CGFloat = 24,
        tint: Color = .clear,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.tint = tint
        self.content = content
    }

    var body: some View {
        content()
            .padding(padding)
            .fortGlass(cornerRadius: cornerRadius, tint: tint)
    }
}

// MARK: - Pulse Modifier

struct PulseModifier: ViewModifier {
    @State private var opacity: Double = 0.5
    func body(content: Content) -> some View {
        content.opacity(opacity).onAppear {
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                opacity = 1.0
            }
        }
    }
}

extension View {
    func pulse() -> some View { modifier(PulseModifier()) }

    // Keep shimmer as a no-op alias so old code doesn't break
    func shimmer() -> some View { self }
}

#Preview {
    ZStack {
        Color(hex: "080818").ignoresSafeArea()
        FortunaCard(tint: .accentPurple) {
            VStack(spacing: 12) {
                Text("Fortuna Card")
                    .font(FortunaFont.displayMedium(20))
                    .foregroundStyle(Color.textPrimary)
                Text("A liquid glass card component.")
                    .font(FortunaFont.body(15))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .padding()
    }
}
