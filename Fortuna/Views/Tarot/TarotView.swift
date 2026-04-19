import SwiftUI

struct TarotView: View {
    @StateObject private var viewModel = TarotViewModel()
    @State private var selectedTab = 0
    @State private var selectedSpreadCard: TarotCard? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                CosmicBackground()

                VStack(spacing: 0) {
                    // Title
                    VStack(spacing: 4) {
                        Text("TAROT")
                            .font(.system(size: 28, weight: .thin, design: .serif))
                            .tracking(10)
                            .foregroundStyle(.celestialGold)
                            .shimmer()
                        Text("The Cards Speak")
                            .font(.system(size: 11, weight: .light))
                            .foregroundStyle(.starWhite.opacity(0.5))
                            .tracking(3)
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 20)

                    // Tab selector
                    HStack(spacing: 0) {
                        ForEach(["Daily", "Monthly", "Yearly"].indices, id: \.self) { i in
                            Button {
                                withAnimation(.spring(response: 0.4)) { selectedTab = i }
                            } label: {
                                Text(["Daily", "Monthly", "Yearly"][i])
                                    .font(.system(size: 13, weight: selectedTab == i ? .semibold : .regular))
                                    .foregroundStyle(selectedTab == i ? .celestialGold : .starWhite.opacity(0.5))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background {
                                        if selectedTab == i {
                                            Capsule()
                                                .fill(.white.opacity(0.08))
                                                .overlay(Capsule().strokeBorder(.celestialGold.opacity(0.4), lineWidth: 0.5))
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)

                    // Tab content
                    TabView(selection: $selectedTab) {
                        DailyTarotTab(viewModel: viewModel)
                            .tag(0)
                        MonthlyTarotTab(viewModel: viewModel)
                            .tag(1)
                        YearlyTarotTab(viewModel: viewModel)
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - Daily Tab

struct DailyTarotTab: View {
    @ObservedObject var viewModel: TarotViewModel
    @State private var showMeaning = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Instruction
                if !viewModel.isCardFlipped {
                    Text("Tap the card to reveal your daily fortune")
                        .font(.system(size: 13, weight: .light))
                        .foregroundStyle(.starWhite.opacity(0.6))
                        .italic()
                } else {
                    Text("Your card for today")
                        .font(.system(size: 13, weight: .light))
                        .foregroundStyle(.celestialGold.opacity(0.8))
                        .italic()
                }

                // Card
                TarotCardView(
                    card: viewModel.dailyCard,
                    isFlippable: !viewModel.hasFlippedToday,
                    externalFlip: $viewModel.isCardFlipped
                )
                .onTapGesture {
                    if !viewModel.hasFlippedToday {
                        viewModel.flipCard()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            withAnimation { showMeaning = true }
                        }
                    }
                }
                .shadow(color: .nebulaGlow.opacity(0.3), radius: 20)

                if viewModel.isCardFlipped && showMeaning {
                    CardMeaningDetail(card: viewModel.dailyCard)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.95)),
                            removal: .opacity
                        ))
                        .padding(.horizontal, 20)
                }

                if viewModel.hasFlippedToday && !viewModel.isCardFlipped {
                    Text("Your card was drawn today. Return tomorrow for a new reading.")
                        .font(.system(size: 12, weight: .light))
                        .foregroundStyle(.starWhite.opacity(0.4))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                Spacer(minLength: 100)
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Monthly Tab

struct MonthlyTarotTab: View {
    @ObservedObject var viewModel: TarotViewModel
    @State private var selectedCard: TarotCard? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                let monthFormatter: DateFormatter = {
                    let f = DateFormatter()
                    f.dateFormat = "MMMM yyyy"
                    return f
                }()

                Text(monthFormatter.string(from: Date()))
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(.celestialGold.opacity(0.7))
                    .tracking(2)

                Text("Three-Card Spread")
                    .font(.system(size: 11, weight: .light))
                    .foregroundStyle(.starWhite.opacity(0.4))
                    .tracking(3)

                HStack(spacing: 12) {
                    ForEach(Array(viewModel.monthlySpread.enumerated()), id: \.offset) { idx, card in
                        VStack(spacing: 8) {
                            Text(viewModel.spreadLabel(for: idx, spreadType: .monthly))
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.celestialGold.opacity(0.7))
                                .tracking(2)

                            SmallCardView(card: card)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.4)) {
                                        selectedCard = selectedCard?.id == card.id ? nil : card
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 16)

                if let card = selectedCard {
                    CardMeaningDetail(card: card)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.95)),
                            removal: .opacity
                        ))
                        .padding(.horizontal, 20)
                }

                Spacer(minLength: 100)
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Yearly Tab

struct YearlyTarotTab: View {
    @ObservedObject var viewModel: TarotViewModel
    @State private var selectedCard: TarotCard? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("\(Calendar.current.component(.year, from: Date()))")
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(.celestialGold.opacity(0.7))
                    .tracking(2)

                Text("Celtic Cross — Five Card Spread")
                    .font(.system(size: 11, weight: .light))
                    .foregroundStyle(.starWhite.opacity(0.4))
                    .tracking(3)

                // Cross layout
                VStack(spacing: 8) {
                    // Top card
                    if viewModel.yearlySpread.count > 2 {
                        HStack {
                            Spacer()
                            YearlyCrossCard(
                                card: viewModel.yearlySpread[2],
                                label: viewModel.spreadLabel(for: 2, spreadType: .yearly),
                                selected: selectedCard?.id == viewModel.yearlySpread[2].id
                            ) {
                                toggleCard(viewModel.yearlySpread[2])
                            }
                            Spacer()
                        }
                    }

                    // Middle row
                    HStack(spacing: 16) {
                        if viewModel.yearlySpread.count > 0 {
                            YearlyCrossCard(
                                card: viewModel.yearlySpread[0],
                                label: viewModel.spreadLabel(for: 0, spreadType: .yearly),
                                selected: selectedCard?.id == viewModel.yearlySpread[0].id
                            ) {
                                toggleCard(viewModel.yearlySpread[0])
                            }
                        }
                        if viewModel.yearlySpread.count > 1 {
                            YearlyCrossCard(
                                card: viewModel.yearlySpread[1],
                                label: viewModel.spreadLabel(for: 1, spreadType: .yearly),
                                selected: selectedCard?.id == viewModel.yearlySpread[1].id
                            ) {
                                toggleCard(viewModel.yearlySpread[1])
                            }
                        }
                        if viewModel.yearlySpread.count > 3 {
                            YearlyCrossCard(
                                card: viewModel.yearlySpread[3],
                                label: viewModel.spreadLabel(for: 3, spreadType: .yearly),
                                selected: selectedCard?.id == viewModel.yearlySpread[3].id
                            ) {
                                toggleCard(viewModel.yearlySpread[3])
                            }
                        }
                    }
                    .padding(.horizontal, 8)

                    // Bottom card
                    if viewModel.yearlySpread.count > 4 {
                        HStack {
                            Spacer()
                            YearlyCrossCard(
                                card: viewModel.yearlySpread[4],
                                label: viewModel.spreadLabel(for: 4, spreadType: .yearly),
                                selected: selectedCard?.id == viewModel.yearlySpread[4].id
                            ) {
                                toggleCard(viewModel.yearlySpread[4])
                            }
                            Spacer()
                        }
                    }
                }

                if let card = selectedCard {
                    CardMeaningDetail(card: card)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.95)),
                            removal: .opacity
                        ))
                        .padding(.horizontal, 20)
                }

                Spacer(minLength: 100)
            }
            .padding(.top, 8)
        }
    }

    private func toggleCard(_ card: TarotCard) {
        withAnimation(.spring(response: 0.4)) {
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
        VStack(spacing: 6) {
            Text(label)
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(.celestialGold.opacity(0.7))
                .tracking(1)
                .multilineTextAlignment(.center)

            SmallCardView(card: card, isSelected: selected)
                .onTapGesture(perform: action)
        }
    }
}

// MARK: - Small Card View

struct SmallCardView: View {
    let card: TarotCard
    var isSelected: Bool = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            isSelected ? .celestialGold : .white.opacity(0.2),
                            lineWidth: isSelected ? 1.5 : 0.5
                        )
                }

            VStack(spacing: 6) {
                Text(card.emoji)
                    .font(.system(size: 28))
                Text(card.name)
                    .font(.system(size: 9, weight: .medium, design: .serif))
                    .foregroundStyle(.starWhite.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(8)
        }
        .frame(width: 90, height: 130)
        .shadow(color: isSelected ? .celestialGold.opacity(0.3) : .clear, radius: 8)
    }
}

// MARK: - Card Meaning Detail

struct CardMeaningDetail: View {
    let card: TarotCard

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(card.emoji).font(.title2)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(card.name)
                            .font(.system(size: 18, weight: .semibold, design: .serif))
                            .foregroundStyle(.starWhite)
                        Text(card.arcana == .major ? "Major Arcana • \(card.number)" :
                             "\(card.suit?.rawValue.capitalized ?? "") • \(card.number)")
                            .font(.caption)
                            .foregroundStyle(.celestialGold.opacity(0.7))
                    }
                    Spacer()
                }

                // Keywords
                HStack(spacing: 6) {
                    ForEach(card.keywords, id: \.self) { kw in
                        Text(kw)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.starWhite.opacity(0.8))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background {
                                Capsule()
                                    .fill(.white.opacity(0.1))
                                    .overlay(Capsule().strokeBorder(.white.opacity(0.2), lineWidth: 0.5))
                            }
                    }
                }

                Divider()
                    .background(.white.opacity(0.1))

                VStack(alignment: .leading, spacing: 8) {
                    Label("Upright", systemImage: "arrow.up")
                        .font(.caption)
                        .foregroundStyle(.auroraGreen)
                    Text(card.uprightMeaning)
                        .font(.system(size: 14, weight: .light, design: .serif))
                        .foregroundStyle(.starWhite.opacity(0.85))
                        .lineSpacing(4)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Label("Reversed", systemImage: "arrow.down")
                        .font(.caption)
                        .foregroundStyle(.marsRed)
                    Text(card.reversedMeaning)
                        .font(.system(size: 14, weight: .light, design: .serif))
                        .foregroundStyle(.starWhite.opacity(0.85))
                        .lineSpacing(4)
                }
            }
            .padding(20)
        }
    }
}

#Preview {
    TarotView()
        .preferredColorScheme(.dark)
}
