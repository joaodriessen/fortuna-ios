import SwiftUI

struct GlassCard<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(
                                colors: [.white.opacity(0.15), .white.opacity(0.03)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(LinearGradient(
                                colors: [.white.opacity(0.6), .white.opacity(0.1), .purple.opacity(0.3)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ), lineWidth: 1)
                    }
            }
    }
}

#Preview {
    ZStack {
        Color.cosmicBackground.ignoresSafeArea()
        GlassCard {
            VStack(spacing: 12) {
                Text("Glass Card")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Text("A beautiful glassmorphism card component.")
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(24)
        }
        .padding()
    }
}
