import SwiftUI

struct CosmicBackground: View {
    @State private var nebulaOffset1 = CGSize.zero
    @State private var nebulaOffset2 = CGSize.zero
    @State private var nebulaOffset3 = CGSize.zero

    var body: some View {
        ZStack {
            // Base space gradient
            LinearGradient(
                colors: [Color.cosmicBackground, Color.nebulaDeep.opacity(0.6), Color.cosmicBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Nebula blob 1 — deep purple
            Circle()
                .fill(Color.nebulaDeep.opacity(0.4))
                .frame(width: 400, height: 400)
                .blur(radius: 80)
                .offset(nebulaOffset1)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: true)) {
                        nebulaOffset1 = CGSize(width: 80, height: -60)
                    }
                }

            // Nebula blob 2 — cosmic blue
            Circle()
                .fill(Color.cosmicBlue.opacity(0.3))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(nebulaOffset2)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 9).repeatForever(autoreverses: true)) {
                        nebulaOffset2 = CGSize(width: -100, height: 80)
                    }
                }

            // Nebula blob 3 — aurora accent
            Circle()
                .fill(Color.auroraGreen.opacity(0.08))
                .frame(width: 250, height: 250)
                .blur(radius: 70)
                .offset(nebulaOffset3)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 15).repeatForever(autoreverses: true).delay(3)) {
                        nebulaOffset3 = CGSize(width: 50, height: 120)
                    }
                }

            // Starfield layer
            StarfieldView()

            // Floating planets
            PlanetView()
        }
    }
}

#Preview {
    CosmicBackground()
}
