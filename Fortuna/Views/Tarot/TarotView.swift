import SwiftUI

struct TarotView: View {
    @StateObject private var viewModel = TarotViewModel()
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            CosmicBackground()

            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Tarot")
                        .font(FortunaFont.display(34))
                        .foregroundStyle(Color.textPrimary)
                    Text("The cards speak in your frequency")
                        .font(FortunaFont.caption(12))
                        .foregroundStyle(Color.textTertiary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 64)
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.bottom, Spacing.lg)

                // Segmented picker
                FortunaPicker(labels: ["Daily", "Monthly", "Yearly"], selected: $selectedTab)
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.bottom, Spacing.md)

                // Content
                TabView(selection: $selectedTab) {
                    DailyTarotTab(viewModel: viewModel).tag(0)
                    MonthlyTarotTab(viewModel: viewModel).tag(1)
                    YearlyTarotTab(viewModel: viewModel).tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.25), value: selectedTab)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Segmented Picker

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

            // Underline indicator
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

// MARK: - Daily Tab

struct DailyTarotTab: View {
    @ObservedObject var viewModel: TarotViewModel
    @State private var showMeaning = false

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                if !viewModel.isCardFlipped {
                    Text("Tap the card to reveal your reading")
                        .font(FortunaFont.caption(13))
                        .foregroundStyle(Color.textTertiary)
                        .italic()
                } else {
                    Text("Your card for today")
                        .font(FortunaFont.caption(13))
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
                        .padding(.horizontal, Spacing.screenHorizontal)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                if viewModel.hasFlippedToday && !viewModel.isCardFlipped {
                    Text("Return tomorrow for a new reading.")
                        .font(FortunaFont.caption(12))
                        .foregroundStyle(Color.textTertiary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                Spacer(minLength: 120)
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
        ScrollView {
            VStack(spacing: Spacing.lg) {
                let mf: DateFormatter = {
                    let f = DateFormatter(); f.dateFormat = "MMMM yyyy"; return f
                }()

                VStack(spacing: 4) {
                    Text(mf.string(from: Date()))
                        .font(FortunaFont.displayMedium(14))
                        .foregroundStyle(Color.accentGold)
                    Text("Three-Card Spread")
                        .font(FortunaFont.caption(11))
                        .foregroundStyle(Color.textTertiary)
                        .tracking(1)
                }

                HStack(spacing: Spacing.md) {
                    ForEach(Array(viewModel.monthlySpread.enumerated()), id: \.offset) { idx, card in
                        VStack(spacing: 6) {
                            Text(viewModel.spreadLabel(for: idx, spreadType: .monthly))
                                .font(FortunaFont.caption(9))
                                .foregroundStyle(Color.accentGold.opacity(0.7))
                                .tracking(1)
                            SmallCardView(card: card, isSelected: selectedCard?.id == card.id)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.35)) {
                                        selectedCard = selectedCard?.id == card.id ? nil : card
                                    }
                                }
                        }
                    }
                }

                if let card = selectedCard {
                    CardMeaningDetail(card: card)
                        .padding(.horizontal, Spacing.screenHorizontal)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                Spacer(minLength: 120)
            }
            .padding(.top, Spacing.xs)
        }
    }
}

// MARK: - Yearly Tab

struct YearlyTarotTab: View {
    @ObservedObject var viewModel: TarotViewModel
    @State private var selectedCard: TarotCard? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                VStack(spacing: 4) {
                    Text("\(Calendar.current.component(.year, from: Date()))")
                        .font(FortunaFont.displayMedium(14))
                        .foregroundStyle(Color.accentGold)
                    Text("Five-Card Cross")
                        .font(FortunaFont.caption(11))
                        .foregroundStyle(Color.textTertiary)
                        .tracking(1)
                }

                // Cross layout
                VStack(spacing: Spacing.sm) {
                    if viewModel.yearlySpread.count > 2 {
                        HStack { Spacer()
                            YearlyCrossCard(card: viewModel.yearlySpread[2],
                                            label: viewModel.spreadLabel(for: 2, spreadType: .yearly),
                                            selected: selectedCard?.id == viewModel.yearlySpread[2].id,
                                            action: { toggle(viewModel.yearlySpread[2]) })
                            Spacer() }
                    }
                    HStack(spacing: Spacing.md) {
                        if viewModel.yearlySpread.count > 0 {
                            YearlyCrossCard(card: viewModel.yearlySpread[0],
                                            label: viewModel.spreadLabel(for: 0, spreadType: .yearly),
                                            selected: selectedCard?.id == viewModel.yearlySpread[0].id,
                                            action: { toggle(viewModel.yearlySpread[0]) })
                        }
                        if viewModel.yearlySpread.count > 1 {
                            YearlyCrossCard(card: viewModel.yearlySpread[1],
                                            label: viewModel.spreadLabel(for: 1, spreadType: .yearly),
                                            selected: selectedCard?.id == viewModel.yearlySpread[1].id,
                                            action: { toggle(viewModel.yearlySpread[1]) })
                        }
                        if viewModel.yearlySpread.count > 3 {
                            YearlyCrossCard(card: viewModel.yearlySpread[3],
                                            label: viewModel.spreadLabel(for: 3, spreadType: .yearly),
                                            selected: selectedCard?.id == viewModel.yearlySpread[3].id,
                                            action: { toggle(viewModel.yearlySpread[3]) })
                        }
                    }
                    if viewModel.yearlySpread.count > 4 {
                        HStack { Spacer()
                            YearlyCrossCard(card: viewModel.yearlySpread[4],
                                            label: viewModel.spreadLabel(for: 4, spreadType: .yearly),
                                            selected: selectedCard?.id == viewModel.yearlySpread[4].id,
                                            action: { toggle(viewModel.yearlySpread[4]) })
                            Spacer() }
                    }
                }

                if let card = selectedCard {
                    CardMeaningDetail(card: card)
                        .padding(.horizontal, Spacing.screenHorizontal)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                Spacer(minLength: 120)
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
                .font(FortunaFont.caption(9))
                .foregroundStyle(Color.accentGold.opacity(0.7))
                .tracking(0.5)
                .multilineTextAlignment(.center)
            SmallCardView(card: card, isSelected: selected)
                .onTapGesture(perform: action)
        }
    }
}

#Preview {
    TarotView()
        .preferredColorScheme(.dark)
}
