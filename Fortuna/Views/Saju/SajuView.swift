import SwiftUI

struct SajuView: View {
    @StateObject private var viewModel = SajuViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                CosmicBackground()

                if viewModel.hasChart, let chart = viewModel.chart {
                    SajuResultView(viewModel: viewModel, chart: chart)
                } else {
                    SajuInputView(viewModel: viewModel)
                }
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - Result View

struct SajuResultView: View {
    @ObservedObject var viewModel: SajuViewModel
    let chart: SajuChart
    @State private var selectedPeriod = 0
    @State private var pillarsAppeared = false

    private var fortuneText: String {
        switch selectedPeriod {
        case 0: return viewModel.dailyFortune
        case 1: return viewModel.monthlyFortune
        default: return viewModel.yearlyFortune
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 6) {
                    Text("사주팔자")
                        .font(.system(size: 32, weight: .thin, design: .serif))
                        .foregroundStyle(.celestialGold)
                        .shimmer()
                    Text("FOUR PILLARS OF DESTINY")
                        .font(.system(size: 9, weight: .light))
                        .foregroundStyle(.starWhite.opacity(0.4))
                        .tracking(3)
                }
                .padding(.top, 64)

                // Four Pillars display
                HStack(spacing: 10) {
                    ForEach(Array(chart.allPillars.enumerated()), id: \.offset) { idx, pillar in
                        PillarCard(
                            pillar: pillar,
                            label: viewModel.pillarLabels[idx],
                            delay: Double(idx) * 0.15
                        )
                        .opacity(pillarsAppeared ? 1 : 0)
                        .offset(y: pillarsAppeared ? 0 : 20)
                        .animation(.spring(response: 0.5).delay(Double(idx) * 0.15), value: pillarsAppeared)
                    }
                }
                .padding(.horizontal, 16)
                .onAppear { pillarsAppeared = true }

                // Five Elements visualization
                ElementsChart(percentages: chart.elementPercentages, dominant: chart.dominantElement)
                    .padding(.horizontal, 20)

                // Dominant element insight
                GlassCard {
                    HStack(spacing: 16) {
                        Text(chart.dominantElement.emoji)
                            .font(.system(size: 40))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Dominant Element")
                                .font(.caption)
                                .foregroundStyle(.starWhite.opacity(0.4))
                                .tracking(2)
                            Text(chart.dominantElement.englishName)
                                .font(.system(size: 22, weight: .light, design: .serif))
                                .foregroundStyle(.celestialGold)
                            Text(chart.dominantElement.rawValue + " · " + chart.dominantElement.koreanName)
                                .font(.system(size: 14, weight: .thin))
                                .foregroundStyle(.starWhite.opacity(0.6))
                        }
                        Spacer()
                    }
                    .padding(20)
                }
                .padding(.horizontal, 20)

                // Period selector
                HStack(spacing: 0) {
                    ForEach(["Daily", "Monthly", "Yearly"].indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.4)) { selectedPeriod = i }
                        } label: {
                            Text(["Daily", "Monthly", "Yearly"][i])
                                .font(.system(size: 13, weight: selectedPeriod == i ? .semibold : .regular))
                                .foregroundStyle(selectedPeriod == i ? .celestialGold : .starWhite.opacity(0.5))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background {
                                    if selectedPeriod == i {
                                        Capsule()
                                            .fill(.white.opacity(0.08))
                                            .overlay(Capsule().strokeBorder(.celestialGold.opacity(0.4), lineWidth: 0.5))
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 20)

                // Fortune reading
                GlassCard {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "yin.yang")
                                .foregroundStyle(.celestialGold)
                            Text(["Daily Reading", "Monthly Reading", "Yearly Reading"][selectedPeriod])
                                .font(.caption)
                                .foregroundStyle(.celestialGold)
                                .tracking(2)
                            Spacer()
                        }

                        Text(fortuneText)
                            .font(.system(size: 14, weight: .light, design: .serif))
                            .foregroundStyle(.starWhite.opacity(0.9))
                            .lineSpacing(6)
                            .id(selectedPeriod)
                    }
                    .padding(22)
                }
                .padding(.horizontal, 20)

                // Reset
                Button {
                    withAnimation(.spring(response: 0.5)) {
                        viewModel.clearChart()
                    }
                } label: {
                    Text("Recalculate with different birth data")
                        .font(.system(size: 12, weight: .light))
                        .foregroundStyle(.starWhite.opacity(0.3))
                        .underline()
                }

                Spacer(minLength: 100)
            }
        }
    }
}

// MARK: - Pillar Card

struct PillarCard: View {
    let pillar: SajuPillar
    let label: String
    let delay: Double

    var body: some View {
        GlassCard {
            VStack(spacing: 8) {
                // Label (multi-line)
                Text(label)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(.celestialGold.opacity(0.7))
                    .tracking(1)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)

                Divider().background(.white.opacity(0.1))

                // Chinese characters
                VStack(spacing: 2) {
                    Text(pillar.stem.chineseName)
                        .font(.system(size: 28, weight: .thin, design: .serif))
                        .foregroundStyle(pillar.stem.element.color)

                    Text(pillar.branch.chineseName)
                        .font(.system(size: 28, weight: .thin, design: .serif))
                        .foregroundStyle(.starWhite.opacity(0.8))
                }

                Divider().background(.white.opacity(0.1))

                // Korean
                VStack(spacing: 2) {
                    Text(pillar.stem.koreanName)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(pillar.stem.element.color.opacity(0.9))
                    Text(pillar.branch.koreanName)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(.starWhite.opacity(0.6))
                }

                // Animal emoji
                Text(pillar.branch.animalEmoji)
                    .font(.system(size: 16))
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Elements Chart

struct ElementsChart: View {
    let percentages: [FiveElement: Double]
    let dominant: FiveElement

    private let orderedElements: [FiveElement] = [.wood, .fire, .earth, .metal, .water]

    var body: some View {
        GlassCard {
            VStack(spacing: 16) {
                Text("Five Elements Analysis")
                    .font(.caption)
                    .foregroundStyle(.celestialGold)
                    .tracking(2)

                // Bar chart
                VStack(spacing: 8) {
                    ForEach(orderedElements, id: \.self) { element in
                        let pct = percentages[element] ?? 0
                        HStack(spacing: 12) {
                            Text(element.emoji + " " + element.englishName)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(.starWhite.opacity(0.8))
                                .frame(width: 90, alignment: .leading)

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(.white.opacity(0.06))

                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(
                                            LinearGradient(
                                                colors: [element.color.opacity(0.8), element.color.opacity(0.4)],
                                                startPoint: .leading, endPoint: .trailing
                                            )
                                        )
                                        .frame(width: geo.size.width * pct)
                                        .shadow(color: element.color.opacity(0.5), radius: 4)
                                }
                                .frame(height: 12)
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                            }
                            .frame(height: 12)

                            Text("\(Int(pct * 100))%")
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .foregroundStyle(.starWhite.opacity(0.5))
                                .frame(width: 32, alignment: .trailing)
                        }
                    }
                }
            }
            .padding(20)
        }
    }
}

extension FiveElement {
    var color: Color {
        switch self {
        case .wood: return .auroraGreen
        case .fire: return .marsRed
        case .earth: return Color(red: 0.8, green: 0.6, blue: 0.3)
        case .metal: return Color(red: 0.8, green: 0.8, blue: 0.9)
        case .water: return .cosmicBlue
        }
    }
}

#Preview {
    SajuView()
        .preferredColorScheme(.dark)
}
