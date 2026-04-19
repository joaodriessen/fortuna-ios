import SwiftUI

struct TarotView: View {
    @StateObject private var viewModel = TarotViewModel()
    @State private var selectedPeriod: FortunePeriod = .daily
    @Namespace private var ns

    var body: some View {
        ZStack {
            CosmicBackground()

            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("TAROT")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(3.0)
                        .foregroundStyle(Color.textTertiary)

                    Text("The cards speak\nin your frequency")
                        .font(.system(size: 36, weight: .ultraLight))
                        .tracking(-0.3)
                        .foregroundStyle(Color.textPrimary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
                .padding(.horizontal, 28)
                .padding(.bottom, 28)

                // Glass pill picker
                HStack(spacing: 8) {
                    ForEach([FortunePeriod.daily, .monthly, .yearly], id: \.label) { period in
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                selectedPeriod = period
                            }
                        } label: {
                            Text(period.label)
                                .font(.system(size: 14, weight: selectedPeriod == period ? .medium : .regular))
                                .tracking(1.0)
                                .foregroundStyle(selectedPeriod == period ? Color.textPrimary : Color.textSecondary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background {
                                    if selectedPeriod == period {
                                        Capsule()
                                            .fill(.ultraThinMaterial)
                                            .overlay(Capsule().strokeBorder(Color.white.opacity(0.18), lineWidth: 0.5))
                                            .matchedGeometryEffect(id: "tarotPill", in: ns)
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 16)

                // Content tabs
                switch selectedPeriod {
                case .daily:
                    DailyTarotTab(viewModel: viewModel)
                case .monthly:
                    MonthlyTarotTab(viewModel: viewModel)
                case .yearly:
                    YearlyTarotTab(viewModel: viewModel)
                }
            }
        }
    }
}

// MARK: - Daily Tab

struct DailyTarotTab: View {
    @ObservedObject var viewModel: TarotViewModel
    @State private var showMeaning = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Spacing.lg) {
                if !viewModel.isCardFlipped {
                    Text("Tap the card to reveal your reading")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.textTertiary)
                        .italic()
                } else {
                    Text("Your card for today")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.accentGold)
                        .italic()
                }

                TarotCardView(
                    card: viewModel.dailyCard,
                    isFlippable: !viewModel.hasFlippedToday,
                    externalFlip: $viewModel.isCardFlipped
                )
                .onTapGesture {
                    if !viewModel.hasFlippedToday {
                        viewModel.flipCard()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            withAnimation(.easeInOut(duration: 0.25)) { showMeaning = true }
                        }
                    }
                }

                if viewModel.isCardFlipped && showMeaning {
                    CardMeaningDetail(card: viewModel.dailyCard)
                        .padding(.horizontal, 20)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                if viewModel.hasFlippedToday && !viewModel.isCardFlipped {
                    Text("Return tomorrow for a new reading.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.textTertiary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                Spacer(minLength: 40)
            }
            .padding(.top, Spacing.xs)
        }
    }
}

// MARK: - Monthly Tab

struct MonthlyTarotTab: View {
    @ObservedObject var viewModel: TarotViewModel
    @State private var selectedCard: TarotCard? = nil

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Spacing.lg) {
                let mf: DateFormatter = {
                    let f = DateFormatter(); f.dateFormat = "MMMM yyyy"; return f
                }()

                VStack(spacing: 4) {
                    Text(mf.string(from: Date()))
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Color.accentGold)
                    Text("Three-Card Spread")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(2.0)
                        .foregroundStyle(Color.textTertiary)
                }

                // Full-width scrollable cards
                VStack(spacing: 16) {
                    ForEach(Array(viewModel.monthlySpread.enumerated()), id: \.offset) { idx, card in
                        MonthlySpreadCard(
                            card: card,
                            label: viewModel.spreadLabel(for: idx, spreadType: .monthly),
                            isSelected: selectedCard?.id == card.id
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35)) {
                                selectedCard = selectedCard?.id == card.id ? nil : card
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)

                if let card = selectedCard {
                    CardMeaningDetail(card: card)
                        .padding(.horizontal, 20)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                Spacer(minLength: 40)
            }
            .padding(.top, Spacing.xs)
        }
    }
}

struct MonthlySpreadCard: View {
    let card: TarotCard
    let label: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 20) {
            // Mini card visual
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(
                                isSelected ? Color.accentGold.opacity(0.6) : Color.white.opacity(0.08),
                                lineWidth: 0.5
                            )
                    )

                VStack(spacing: 6) {
                    Image(systemName: card.symbolName)
                        .font(.system(size: 22, weight: .ultraLight))
                        .foregroundStyle(isSelected ? Color.accentGold : Color.textSecondary)
                    Text(card.name)
                        .font(.system(size: 10, weight: .medium))
                        .tracking(0.5)
                        .foregroundStyle(Color.textPrimary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(8)
            }
            .frame(width: 80, height: 110)

            VStack(alignment: .leading, spacing: 8) {
                Text(label.uppercased())
                    .font(.system(size: 11, weight: .medium))
                    .tracking(2.0)
                    .foregroundStyle(Color.accentGold.opacity(0.7))

                Text(card.name)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.textPrimary)

                Text(card.keywords.prefix(3).joined(separator: " · "))
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()

            Image(systemName: isSelected ? "chevron.up" : "chevron.down")
                .font(.system(size: 12, weight: .light))
                .foregroundStyle(Color.textTertiary)
        }
        .padding(20)
        .fortGlass(cornerRadius: 20, tint: isSelected ? Color.tarotTint.opacity(0.08) : .clear)
    }
}

// MARK: - Yearly Tab

struct YearlyTarotTab: View {
    @ObservedObject var viewModel: TarotViewModel
    @State private var selectedCard: TarotCard? = nil

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Spacing.lg) {
                VStack(spacing: 4) {
                    Text("\(Calendar.current.component(.year, from: Date()))")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Color.accentGold)
                    Text("Five-Card Cross")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(2.0)
                        .foregroundStyle(Color.textTertiary)
                }

                // Cross layout
                VStack(spacing: Spacing.sm) {
                    if viewModel.yearlySpread.count > 2 {
                        HStack {
                            Spacer()
                            YearlyCrossCard(
                                card: viewModel.yearlySpread[2],
                                label: viewModel.spreadLabel(for: 2, spreadType: .yearly),
                                selected: selectedCard?.id == viewModel.yearlySpread[2].id,
                                action: { toggle(viewModel.yearlySpread[2]) }
                            )
                            Spacer()
                        }
                    }
                    HStack(spacing: Spacing.md) {
                        if viewModel.yearlySpread.count > 0 {
                            YearlyCrossCard(
                                card: viewModel.yearlySpread[0],
                                label: viewModel.spreadLabel(for: 0, spreadType: .yearly),
                                selected: selectedCard?.id == viewModel.yearlySpread[0].id,
                                action: { toggle(viewModel.yearlySpread[0]) }
                            )
                        }
                        if viewModel.yearlySpread.count > 1 {
                            YearlyCrossCard(
                                card: viewModel.yearlySpread[1],
                                label: viewModel.spreadLabel(for: 1, spreadType: .yearly),
                                selected: selectedCard?.id == viewModel.yearlySpread[1].id,
                                action: { toggle(viewModel.yearlySpread[1]) }
                            )
                        }
                        if viewModel.yearlySpread.count > 3 {
                            YearlyCrossCard(
                                card: viewModel.yearlySpread[3],
                                label: viewModel.spreadLabel(for: 3, spreadType: .yearly),
                                selected: selectedCard?.id == viewModel.yearlySpread[3].id,
                                action: { toggle(viewModel.yearlySpread[3]) }
                            )
                        }
                    }
                    if viewModel.yearlySpread.count > 4 {
                        HStack {
                            Spacer()
                            YearlyCrossCard(
                                card: viewModel.yearlySpread[4],
                                label: viewModel.spreadLabel(for: 4, spreadType: .yearly),
                                selected: selectedCard?.id == viewModel.yearlySpread[4].id,
                                action: { toggle(viewModel.yearlySpread[4]) }
                            )
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 20)

                if let card = selectedCard {
                    CardMeaningDetail(card: card)
                        .padding(.horizontal, 20)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                Spacer(minLength: 40)
            }
            .padding(.top, Spacing.xs)
        }
    }

    private func toggle(_ card: TarotCard) {
        withAnimation(.spring(response: 0.35)) {
            selectedCard = selectedCard?.id == card.id ? nil : card
        }
    }
}

struct YearlyCrossCard: View {
    let card: TarotCard
    let label: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        VStack(spacing: 5) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .tracking(0.5)
                .foregroundStyle(Color.accentGold.opacity(0.7))
                .multilineTextAlignment(.center)
            SmallCardView(card: card, isSelected: selected)
                .onTapGesture(perform: action)
        }
    }
}

// MARK: - Segmented Picker (legacy, kept for SajuView compatibility)

struct FortunaPicker: View {
    let labels: [String]
    @Binding var selected: Int

    var body: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 0) {
                ForEach(labels.indices, id: \.self) { i in
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            selected = i
                        }
                    } label: {
                        Text(labels[i])
                            .font(FortunaFont.body(13))
                            .foregroundStyle(selected == i ? Color.textPrimary : Color.textTertiary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Spacing.sm)
                    }
                    .buttonStyle(.plain)
                }
            }

            GeometryReader { geo in
                let w = geo.size.width / CGFloat(labels.count)
                Rectangle()
                    .fill(Color.accentGold)
                    .frame(width: w, height: 1.5)
                    .cornerRadius(1)
                    .offset(x: w * CGFloat(selected))
                    .animation(.spring(response: 0.35, dampingFraction: 0.75), value: selected)
            }
            .frame(height: 1.5)
        }
    }
}

#Preview {
    TarotView()
        .preferredColorScheme(.dark)
}
