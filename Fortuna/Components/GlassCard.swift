import SwiftUI

struct FortunaCard<Content: View>: View {
    var padding: CGFloat = Spacing.lg
    var tint: Color = .clear
    let content: () -> Content

    init(padding: CGFloat = Spacing.lg, tint: Color = .clear, @ViewBuilder content: @escaping () -> Content) {
        self.padding = padding
        self.tint = tint
        self.content = content
    }

    var body: some View {
        content()
            .padding(padding)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.surfaceBase)
                    .overlay {
                        if tint != .clear {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(tint.opacity(0.06))
                        }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .strokeBorder(Color.cardBorder, lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.35), radius: 24, x: 0, y: 8)
            }
    }
}

// MARK: - Pulse Modifier (replaces shimmer)

struct PulseModifier: ViewModifier {
    @State private var opacity: Double = 0.4

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                    opacity = 1.0
                }
            }
    }
}

extension View {
    func pulse() -> some View {
        modifier(PulseModifier())
    }

    // Keep shimmer as a no-op alias so old code doesn't break during migration
    func shimmer() -> some View {
        self
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        FortunaCard(tint: .accentPurple) {
            VStack(spacing: 12) {
                Text("Fortuna Card")
                    .font(FortunaFont.displayMedium(20))
                    .foregroundStyle(Color.textPrimary)
                Text("A refined card component.")
                    .font(FortunaFont.body(15))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .padding()
    }
}
