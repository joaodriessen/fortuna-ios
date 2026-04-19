import SwiftUI

struct TarotCardView: View {
    let card: TarotCard
    let isFlippable: Bool
    @State private var isFlipped = false
    @Binding var externalFlip: Bool

    init(card: TarotCard, isFlippable: Bool = true, externalFlip: Binding<Bool> = .constant(false)) {
        self.card = card
        self.isFlippable = isFlippable
        self._externalFlip = externalFlip
    }

    var body: some View {
        ZStack {
            // Card Back
            CardBackView()
                .rotation3DEffect(
                    .degrees(isFlipped ? 90 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
                .opacity(isFlipped ? 0 : 1)

            // Card Front
            CardFrontView(card: card)
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -90),
                    axis: (x: 0, y: 1, z: 0)
                )
                .opacity(isFlipped ? 1 : 0)
        }
        .frame(width: 200, height: 320)
        .onTapGesture {
            guard isFlippable && !isFlipped else { return }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isFlipped = true
                externalFlip = true
            }
        }
        .onChange(of: externalFlip) { _, newVal in
            if newVal && !isFlipped {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isFlipped = true
                }
            }
        }
    }
}

struct CardBackView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.05, blue: 0.18),
                        Color.nebulaDeep,
                        Color(red: 0.02, green: 0.02, blue: 0.12)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))

            // Outer border
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    LinearGradient(
                        colors: [.celestialGold.opacity(0.8), .celestialGold.opacity(0.2), .celestialGold.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )

            // Mandala geometry
            MandalaPattern()
                .padding(20)

            // Inner corner ornaments
            GeometryReader { geo in
                ForEach(0..<4) { i in
                    let x: CGFloat = i % 2 == 0 ? 12 : geo.size.width - 24
                    let y: CGFloat = i < 2 ? 12 : geo.size.height - 24
                    Text("✦")
                        .font(.system(size: 10))
                        .foregroundStyle(.celestialGold.opacity(0.6))
                        .position(x: x, y: y)
                }
            }

            Text("FORTUNA")
                .font(.system(size: 8, weight: .light))
                .tracking(4)
                .foregroundStyle(.celestialGold.opacity(0.5))
                .padding(.bottom, 16)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

struct MandalaPattern: View {
    var body: some View {
        ZStack {
            // Concentric circles
            ForEach([0.85, 0.65, 0.45, 0.25], id: \.self) { scale in
                Circle()
                    .strokeBorder(.celestialGold.opacity(0.15), lineWidth: 0.5)
                    .scaleEffect(scale)
            }

            // Radial lines
            ForEach(0..<12) { i in
                Rectangle()
                    .fill(.celestialGold.opacity(0.12))
                    .frame(width: 0.5, height: .infinity)
                    .rotationEffect(.degrees(Double(i) * 30))
            }

            // Star of David-like hexagon
            ForEach(0..<2) { j in
                RegularPolygon(sides: 6)
                    .stroke(Color.celestialGold.opacity(0.3), lineWidth: 0.8)
                    .rotationEffect(.degrees(Double(j) * 30))
                    .scaleEffect(0.55)
            }

            // Center star
            Image(systemName: "star.fill")
                .font(.system(size: 20))
                .foregroundStyle(.celestialGold.opacity(0.5))
        }
    }
}

struct RegularPolygon: Shape {
    let sides: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let angleStep = (2 * Double.pi) / Double(sides)

        for i in 0..<sides {
            let angle = Double(i) * angleStep - Double.pi / 2
            let x = center.x + CGFloat(cos(angle)) * radius
            let y = center.y + CGFloat(sin(angle)) * radius
            if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
            else { path.addLine(to: CGPoint(x: x, y: y)) }
        }
        path.closeSubpath()
        return path
    }
}

struct CardFrontView: View {
    let card: TarotCard

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [.white.opacity(0.12), .clear],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            LinearGradient(
                                colors: [.celestialGold.opacity(0.6), .clear, .purple.opacity(0.4)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }

            VStack(spacing: 12) {
                // Card number/arcana label
                Text(card.arcana == .major ? "MAJOR ARCANA" : card.suit?.rawValue.uppercased() ?? "")
                    .font(.system(size: 8, weight: .medium))
                    .tracking(3)
                    .foregroundStyle(.celestialGold.opacity(0.7))

                // Emoji / artwork placeholder
                Text(card.emoji)
                    .font(.system(size: 52))
                    .shadow(color: .celestialGold.opacity(0.4), radius: 10)

                // Card name
                Text(card.name)
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .foregroundStyle(.starWhite)
                    .multilineTextAlignment(.center)

                Text(card.number)
                    .font(.system(size: 12, weight: .light))
                    .foregroundStyle(.celestialGold.opacity(0.8))

                // Divider
                Rectangle()
                    .fill(.celestialGold.opacity(0.3))
                    .frame(height: 0.5)
                    .padding(.horizontal, 20)

                // Keywords
                HStack(spacing: 6) {
                    ForEach(card.keywords.prefix(3), id: \.self) { kw in
                        Text(kw)
                            .font(.system(size: 8, weight: .medium))
                            .foregroundStyle(.starWhite.opacity(0.7))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background {
                                Capsule()
                                    .fill(.white.opacity(0.08))
                                    .overlay(Capsule().strokeBorder(.white.opacity(0.15), lineWidth: 0.5))
                            }
                    }
                }

                // Symbolism
                Text(card.symbolism)
                    .font(.system(size: 9, weight: .light, design: .serif))
                    .foregroundStyle(.starWhite.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .italic()
                    .padding(.horizontal, 12)
            }
            .padding(16)
        }
    }
}

#Preview {
    ZStack {
        Color.cosmicBackground.ignoresSafeArea()
        TarotCardView(card: TarotCard.deck[0])
    }
}
