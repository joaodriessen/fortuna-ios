import SwiftUI

struct ZodiacWheelView: View {
    let userSign: ZodiacSign
    @State private var rotation: Double = 0
    @State private var pulse: Bool = false

    private let allSigns = ZodiacData.allSigns

    var body: some View {
        ZStack {
            // Outer decorative rings
            ForEach([1.0, 0.92, 0.84], id: \.self) { scale in
                Circle()
                    .strokeBorder(Color.celestialGold.opacity(0.08 + (1 - scale) * 0.2), lineWidth: 0.5)
                    .scaleEffect(scale)
            }

            // Rotating sign symbols
            ForEach(Array(allSigns.enumerated()), id: \.offset) { index, sign in
                let angle = Double(index) * 30 - 90
                let isUserSign = sign.name == userSign.name

                VStack(spacing: 2) {
                    Text(sign.symbol)
                        .font(.system(size: isUserSign ? 22 : 16))
                        .foregroundStyle(isUserSign ? Color.celestialGold : Color.starWhite.opacity(0.55))
                        .scaleEffect(isUserSign ? (pulse ? 1.25 : 1.15) : 1.0)
                        .shadow(color: isUserSign ? .celestialGold.opacity(0.8) : .clear, radius: 8)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulse)
                }
                .offset(
                    x: cos(angle * .pi / 180) * 125,
                    y: sin(angle * .pi / 180) * 125
                )
            }

            // Center glow
            Circle()
                .fill(RadialGradient(
                    colors: [Color.celestialGold.opacity(0.15), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: 50
                ))
                .frame(width: 100, height: 100)

            // Center content
            VStack(spacing: 4) {
                Text(userSign.symbol)
                    .font(.system(size: 36, weight: .thin))
                    .foregroundStyle(.celestialGold)
                Text(userSign.name)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.starWhite.opacity(0.8))
                    .tracking(2)
                Text(userSign.element.emoji)
                    .font(.system(size: 14))
            }
        }
        .frame(width: 300, height: 300)
        .rotationEffect(.degrees(rotation))
        .onAppear {
            withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            pulse = true
        }
    }
}

#Preview {
    ZStack {
        Color.cosmicBackground.ignoresSafeArea()
        ZodiacWheelView(userSign: ZodiacData.aries)
    }
}
