import SwiftUI

struct PlanetView: View {
    @State private var jupiterOffset = CGSize.zero
    @State private var moonOffset = CGSize.zero
    @State private var neptuneOffset = CGSize.zero
    @State private var jupiterScale: CGFloat = 1.0
    @State private var moonScale: CGFloat = 1.0
    @State private var neptuneScale: CGFloat = 1.0

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Jupiter — top right
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.95, green: 0.82, blue: 0.65),
                                    Color(red: 0.78, green: 0.55, blue: 0.32),
                                    Color(red: 0.55, green: 0.32, blue: 0.15)
                                ],
                                center: .topLeading,
                                startRadius: 5,
                                endRadius: 50
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: Color(red: 0.9, green: 0.6, blue: 0.3).opacity(0.6), radius: 20)
                    // Ring
                    Ellipse()
                        .strokeBorder(Color(red: 0.9, green: 0.75, blue: 0.5).opacity(0.4), lineWidth: 1.5)
                        .frame(width: 80, height: 20)
                        .rotationEffect(.degrees(-15))
                }
                .offset(x: geo.size.width * 0.75 + jupiterOffset.width,
                        y: geo.size.height * 0.08 + jupiterOffset.height)
                .scaleEffect(jupiterScale)

                // Moon — middle left
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.92, green: 0.92, blue: 0.95),
                                Color(red: 0.65, green: 0.65, blue: 0.72),
                                Color(red: 0.4, green: 0.4, blue: 0.48)
                            ],
                            center: .topLeading,
                            startRadius: 3,
                            endRadius: 30
                        )
                    )
                    .frame(width: 30, height: 30)
                    .shadow(color: Color.starWhite.opacity(0.5), radius: 15)
                    .offset(x: geo.size.width * 0.05 + moonOffset.width,
                            y: geo.size.height * 0.42 + moonOffset.height)
                    .scaleEffect(moonScale)

                // Neptune — lower area
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 0.3, green: 0.65, blue: 0.95),
                                    Color(red: 0.1, green: 0.35, blue: 0.8),
                                    Color(red: 0.05, green: 0.15, blue: 0.55)
                                ],
                                center: .topLeading,
                                startRadius: 4,
                                endRadius: 40
                            )
                        )
                        .frame(width: 40, height: 40)
                        .shadow(color: Color.cosmicBlue.opacity(0.7), radius: 18)
                    // Atmospheric swirl
                    Circle()
                        .strokeBorder(Color(red: 0.5, green: 0.8, blue: 1.0).opacity(0.3), lineWidth: 0.5)
                        .frame(width: 55, height: 55)
                }
                .offset(x: geo.size.width * 0.65 + neptuneOffset.width,
                        y: geo.size.height * 0.72 + neptuneOffset.height)
                .scaleEffect(neptuneScale)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                    jupiterOffset = CGSize(width: 12, height: -15)
                }
                withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                    jupiterScale = 1.05
                }
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true).delay(1)) {
                    moonOffset = CGSize(width: -10, height: 18)
                }
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true).delay(0.5)) {
                    moonScale = 1.08
                }
                withAnimation(.easeInOut(duration: 7).repeatForever(autoreverses: true).delay(2)) {
                    neptuneOffset = CGSize(width: 15, height: -12)
                }
                withAnimation(.easeInOut(duration: 5.5).repeatForever(autoreverses: true).delay(1.5)) {
                    neptuneScale = 1.06
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

#Preview {
    ZStack {
        Color.cosmicBackground.ignoresSafeArea()
        PlanetView()
    }
}
