import SwiftUI

struct ZodiacWheelView: View {
    let userSign: ZodiacSign
    @State private var rotation: Double = 0

    private let allSigns = ZodiacData.allSigns

    var body: some View {
        ZStack {
            // Thin stroke circle
            Circle()
                .strokeBorder(Color.accentGold.opacity(0.15), lineWidth: 0.5)
                .frame(width: 260, height: 260)

            Circle()
                .strokeBorder(Color.white.opacity(0.04), lineWidth: 0.5)
                .frame(width: 220, height: 220)

            // Sign symbols on the ring
            ForEach(Array(allSigns.enumerated()), id: \.offset) { index, sign in
                let angle = Double(index) * 30 - 90
                let isUser = sign.name == userSign.name

                Text(sign.symbol)
                    .font(.system(size: isUser ? 20 : 14, weight: .ultraLight))
                    .foregroundStyle(isUser ? Color.accentGold : Color.textTertiary)
                    .offset(
                        x: cos(angle * .pi / 180) * 120,
                        y: sin(angle * .pi / 180) * 120
                    )
                    // Counter-rotate to keep symbols upright as wheel turns
                    .rotationEffect(.degrees(-rotation))
            }

            // Center
            VStack(spacing: 4) {
                Text(userSign.symbol)
                    .font(.system(size: 38, weight: .ultraLight))
                    .foregroundStyle(Color.accentGold)
                Text(userSign.name)
                    .font(FortunaFont.caption(11))
                    .foregroundStyle(Color.textSecondary)
                    .tracking(1.5)
            }
        }
        .frame(width: 280, height: 280)
        .rotationEffect(.degrees(rotation))
        .onAppear {
            withAnimation(.linear(duration: 90).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        ZodiacWheelView(userSign: ZodiacData.aries)
    }
}
