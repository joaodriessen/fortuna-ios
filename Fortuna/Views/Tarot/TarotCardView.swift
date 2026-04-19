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
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(hex: "0F0F28"))

            // Concentric diamond pattern in very muted gold
            ForEach([0.85, 0.65, 0.45, 0.25], id: \.self) { scale in
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .strokeBorder(Color.accentGold.opacity(0.15), lineWidth: 0.5)
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(45))
            }

            // Centre glyph
            Image(systemName: "sparkle")
                .font(.system(size: 28, weight: .ultraLight))
                .foregroundStyle(Color.accentGold.opacity(0.5))

            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
        }
        .frame(width: 200, height: 320)
    }
}

// MARK: - Card Front

struct CardFrontView: View {
    let card: TarotCard

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)

            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.accentGold.opacity(0.4), Color.accentPurple.opacity(0.2)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )

            VStack(spacing: Spacing.sm) {
                // Arcana label
                Text(card.arcana == .major ? "MAJOR ARCANA" : (card.suit?.rawValue.uppercased() ?? ""))
                    .font(.system(size: 10, weight: .medium))
                    .tracking(2.5)
                    .foregroundStyle(Color.accentGold.opacity(0.6))

                // Symbol
                Image(systemName: card.symbolName)
                    .font(.system(size: 48, weight: .ultraLight))
                    .foregroundStyle(Color.accentGold)
                    .frame(height: 64)

                // Name — 32pt as specified
                Text(card.name)
                    .font(.system(size: 32, weight: .ultraLight))
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)

                Text(card.number)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color.textSecondary)

                Rectangle()
                    .fill(Color.accentGold.opacity(0.2))
                    .frame(height: 0.5)
                    .padding(.horizontal, Spacing.lg)

                // Keywords
                HStack(spacing: 4) {
                    ForEach(card.keywords.prefix(3), id: \.self) { kw in
                        Text(kw)
                            .font(.system(size: 10, weight: .regular))
                            .foregroundStyle(Color.textSecondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background {
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .overlay(Capsule().strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5))
                            }
                    }
                }

                Text(card.symbolism)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(Color.textTertiary)
                    .multilineTextAlignment(.center)
                    .italic()
                    .padding(.horizontal, Spacing.md)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Spacing.md)
        }
        .frame(width: 200, height: 320)
    }
}

// MARK: - Small Card

struct SmallCardView: View {
    let card: TarotCard
    var isSelected: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
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
                    .font(.system(size: 9, weight: .medium))
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
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: card.symbolName)
                    .font(.system(size: 24, weight: .ultraLight))
                    .foregroundStyle(Color.accentGold)
                    .frame(width: 36)

                VStack(alignment: .leading, spacing: 2) {
                    Text(card.name)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(Color.textPrimary)
                    Text(card.arcana == .major
                         ? "Major Arcana · \(card.number)"
                         : "\(card.suit?.rawValue.capitalized ?? "") · \(card.number)")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Color.accentGold)
                }
                Spacer()
            }

            // Keywords row
            HStack(spacing: 5) {
                ForEach(card.keywords, id: \.self) { kw in
                    Text(kw)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(Color.textSecondary)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background {
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .overlay(Capsule().strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5))
                        }
                }
            }

            Rectangle()
                .fill(Color.white.opacity(0.08))
                .frame(height: 0.5)

            VStack(alignment: .leading, spacing: 6) {
                Label("Upright", systemImage: "arrow.up")
                    .font(.system(size: 11, weight: .medium))
                    .tracking(0.5)
                    .foregroundStyle(Color.sajuTint)
                Text(card.uprightMeaning)
                    .font(.system(size: 18, weight: .light))
                    .foregroundStyle(Color.textPrimary)
                    .lineSpacing(6)
            }

            VStack(alignment: .leading, spacing: 6) {
                Label("Reversed", systemImage: "arrow.down")
                    .font(.system(size: 11, weight: .medium))
                    .tracking(0.5)
                    .foregroundStyle(Color.tarotTint)
                Text(card.reversedMeaning)
                    .font(.system(size: 18, weight: .light))
                    .foregroundStyle(Color.textPrimary)
                    .lineSpacing(6)
            }
        }
        .padding(24)
        .fortGlass(cornerRadius: 24, tint: Color.tarotTint.opacity(0.06))
    }
}

#Preview {
    ZStack {
        CosmicBackground()
        TarotCardView(card: TarotCard.deck[0])
    }
}
