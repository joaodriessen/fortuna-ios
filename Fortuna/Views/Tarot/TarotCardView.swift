import SwiftUI

// MARK: - Main Card View (flippable)

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
            CardBackView()
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

            CardFrontView(card: card)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(width: 200, height: 320)
        .onTapGesture {
            guard isFlippable && !isFlipped else { return }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.85)) {
                isFlipped = true
                externalFlip = true
            }
        }
        .onChange(of: externalFlip) { _, newVal in
            if newVal && !isFlipped {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.85)) {
                    isFlipped = true
                }
            }
        }
    }
}

// MARK: - Card Back

struct CardBackView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.surfaceBase)

            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.accentGold.opacity(0.3), lineWidth: 1)

            // Geometric pattern: concentric squares rotated
            GeometryReader { geo in
                let s = min(geo.size.width, geo.size.height)
                ZStack {
                    ForEach([0.85, 0.68, 0.51, 0.34], id: \.self) { scale in
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(Color.accentGold.opacity(0.10), lineWidth: 0.5)
                            .frame(width: s * scale, height: s * scale)
                            .rotationEffect(.degrees(15))
                    }
                    ForEach([0.76, 0.59, 0.42], id: \.self) { scale in
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(Color.accentGold.opacity(0.07), lineWidth: 0.5)
                            .frame(width: s * scale, height: s * scale)
                        }
                    Image(systemName: "sparkle")
                        .font(.system(size: 18, weight: .ultraLight))
                        .foregroundStyle(Color.accentGold.opacity(0.5))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            // Label
            Text("FORTUNA")
                .font(FortunaFont.caption(7))
                .tracking(4)
                .foregroundStyle(Color.accentGold.opacity(0.4))
                .padding(.bottom, 16)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

// MARK: - Card Front

struct CardFrontView: View {
    let card: TarotCard

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.surfaceBase)

            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.accentGold.opacity(0.4), Color.accentPurple.opacity(0.2)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )

            VStack(spacing: Spacing.sm) {
                // Arcana label
                Text(card.arcana == .major ? "MAJOR ARCANA" : (card.suit?.rawValue.uppercased() ?? ""))
                    .font(FortunaFont.caption(8))
                    .tracking(2.5)
                    .foregroundStyle(Color.accentGold.opacity(0.6))

                // Symbol
                Image(systemName: card.symbolName)
                    .font(.system(size: 44, weight: .ultraLight))
                    .foregroundStyle(Color.accentGold)
                    .frame(height: 60)

                // Name
                Text(card.name)
                    .font(FortunaFont.displayMedium(16))
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)

                Text(card.number)
                    .font(FortunaFont.caption(11))
                    .foregroundStyle(Color.textSecondary)

                Rectangle()
                    .fill(Color.accentGold.opacity(0.2))
                    .frame(height: 0.5)
                    .padding(.horizontal, Spacing.lg)

                // Keywords
                HStack(spacing: 4) {
                    ForEach(card.keywords.prefix(3), id: \.self) { kw in
                        Text(kw)
                            .font(FortunaFont.caption(8))
                            .foregroundStyle(Color.textSecondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background {
                                Capsule()
                                    .fill(Color.surfaceRaised)
                            }
                    }
                }

                Text(card.symbolism)
                    .font(FortunaFont.caption(9))
                    .foregroundStyle(Color.textTertiary)
                    .multilineTextAlignment(.center)
                    .italic()
                    .padding(.horizontal, Spacing.md)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Spacing.md)
        }
    }
}

// MARK: - Small Card

struct SmallCardView: View {
    let card: TarotCard
    var isSelected: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.surfaceBase)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            isSelected ? Color.accentGold : Color.white.opacity(0.08),
                            lineWidth: isSelected ? 1 : 0.5
                        )
                }

            VStack(spacing: 5) {
                Image(systemName: card.symbolName)
                    .font(.system(size: 20, weight: .ultraLight))
                    .foregroundStyle(isSelected ? Color.accentGold : Color.textSecondary)

                Text(card.name)
                    .font(FortunaFont.caption(8))
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(6)
        }
        .frame(width: 88, height: 124)
        .shadow(color: isSelected ? Color.accentGold.opacity(0.25) : .clear, radius: 8)
    }
}

// MARK: - Card Meaning Detail

struct CardMeaningDetail: View {
    let card: TarotCard

    var body: some View {
        FortunaCard(padding: Spacing.md) {
            VStack(alignment: .leading, spacing: Spacing.md) {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: card.symbolName)
                        .font(.system(size: 22, weight: .ultraLight))
                        .foregroundStyle(Color.accentGold)
                        .frame(width: 32)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(card.name)
                            .font(FortunaFont.displayMedium(17))
                            .foregroundStyle(Color.textPrimary)
                        Text(card.arcana == .major
                             ? "Major Arcana · \(card.number)"
                             : "\(card.suit?.rawValue.capitalized ?? "") · \(card.number)")
                            .font(FortunaFont.caption(11))
                            .foregroundStyle(Color.accentGold)
                    }
                    Spacer()
                }

                // Keywords row
                HStack(spacing: 5) {
                    ForEach(card.keywords, id: \.self) { kw in
                        Text(kw)
                            .font(FortunaFont.caption(10))
                            .foregroundStyle(Color.textSecondary)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background {
                                Capsule().fill(Color.surfaceRaised)
                            }
                    }
                }

                Rectangle()
                    .fill(Color.divider)
                    .frame(height: 0.5)

                VStack(alignment: .leading, spacing: 6) {
                    Label("Upright", systemImage: "arrow.up")
                        .font(FortunaFont.caption(11))
                        .foregroundStyle(Color.sajuTint)
                    Text(card.uprightMeaning)
                        .font(FortunaFont.body(13))
                        .foregroundStyle(Color.textSecondary)
                        .lineSpacing(4)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Label("Reversed", systemImage: "arrow.down")
                        .font(FortunaFont.caption(11))
                        .foregroundStyle(Color.tarotTint)
                    Text(card.reversedMeaning)
                        .font(FortunaFont.body(13))
                        .foregroundStyle(Color.textSecondary)
                        .lineSpacing(4)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        TarotCardView(card: TarotCard.deck[0])
    }
}
