import SwiftUI

struct SajuView: View {
    @StateObject private var viewModel = SajuViewModel()

    var body: some View {
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

// MARK: - Result View

struct SajuResultView: View {
    @ObservedObject var viewModel: SajuViewModel
    let chart: SajuChart
    @State private var selectedPeriod = 0
    @State private var pillarsAppeared = false

    private var fortuneText: String {
        [viewModel.dailyFortune, viewModel.monthlyFortune, viewModel.yearlyFortune][selectedPeriod]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("사주팔자")
                        .font(FortunaFont.display(34))
                        .foregroundStyle(Color.textPrimary)
                    Text("Four Pillars of Destiny")
                        .font(FortunaFont.caption(13))
                        .foregroundStyle(Color.textTertiary)
                        .tracking(1)
                }
                .padding(.top, 64)
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.bottom, Spacing.xl)

                // Four Pillars table
                FortunaCard(padding: Spacing.md, tint: Color.sajuTint) {
                    VStack(spacing: 0) {
                        // Column labels
                        HStack(spacing: 0) {
                            ForEach(Array(viewModel.pillarLabels.enumerated()), id: \.offset) { idx, lbl in
                                Text(lbl.components(separatedBy: "\n").first ?? lbl)
                                    .font(FortunaFont.caption(9))
                                    .foregroundStyle(Color.accentGold.opacity(0.7))
                                    .tracking(1)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.bottom, Spacing.sm)

                        Rectangle()
                            .fill(Color.divider)
                            .frame(height: 0.5)
                            .padding(.bottom, Spacing.md)

                        // Stems row (Chinese)
                        HStack(spacing: 0) {
                            ForEach(Array(chart.allPillars.enumerated()), id: \.offset) { idx, pillar in
                                Text(pillar.stem.chineseName)
                                    .font(.system(size: 32, weight: .ultraLight))
                                    .foregroundStyle(elementColor(pillar.stem.element))
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .opacity(pillarsAppeared ? 1 : 0)
                        .offset(y: pillarsAppeared ? 0 : 8)
                        .animation(.spring(response: 0.5).delay(0.05), value: pillarsAppeared)

                        // Branches row (Chinese)
                        HStack(spacing: 0) {
                            ForEach(Array(chart.allPillars.enumerated()), id: \.offset) { idx, pillar in
                                Text(pillar.branch.chineseName)
                                    .font(.system(size: 32, weight: .ultraLight))
                                    .foregroundStyle(Color.textSecondary)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .opacity(pillarsAppeared ? 1 : 0)
                        .offset(y: pillarsAppeared ? 0 : 8)
                        .animation(.spring(response: 0.5).delay(0.12), value: pillarsAppeared)
                        .padding(.bottom, Spacing.md)

                        Rectangle()
                            .fill(Color.divider)
                            .frame(height: 0.5)
                            .padding(.bottom, Spacing.sm)

                        // Korean labels row
                        HStack(spacing: 0) {
                            ForEach(Array(chart.allPillars.enumerated()), id: \.offset) { _, pillar in
                                VStack(spacing: 1) {
                                    Text(pillar.stem.koreanName)
                                        .font(FortunaFont.caption(11))
                                        .foregroundStyle(elementColor(pillar.stem.element).opacity(0.8))
                                    Text(pillar.branch.koreanName)
                                        .font(FortunaFont.caption(11))
                                        .foregroundStyle(Color.textTertiary)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.bottom, Spacing.sm)

                        // Korean pillar labels row
                        HStack(spacing: 0) {
                            ForEach(Array(viewModel.pillarLabels.enumerated()), id: \.offset) { _, lbl in
                                Text(lbl.components(separatedBy: "\n").last ?? "")
                                    .font(FortunaFont.caption(9))
                                    .foregroundStyle(Color.textTertiary)
                                    .tracking(0.5)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.bottom, Spacing.lg)
                .onAppear { pillarsAppeared = true }

                // Five elements bars
                FortunaCard(padding: Spacing.lg, tint: Color.sajuTint) {
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("Five Elements · 오행")
                            .font(FortunaFont.caption(11))
                            .foregroundStyle(Color.accentGold)
                            .tracking(2)

                        ForEach(FiveElement.allCases, id: \.self) { element in
                            let pct = chart.elementPercentages[element] ?? 0
                            HStack(spacing: Spacing.sm) {
                                Image(systemName: element.symbolName)
                                    .font(.system(size: 12))
                                    .foregroundStyle(elementColor(element))
                                    .frame(width: 16)

                                Text(element.englishName)
                                    .font(FortunaFont.caption(11))
                                    .foregroundStyle(Color.textSecondary)
                                    .frame(width: 46, alignment: .leading)

                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color.surfaceRaised)
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(elementColor(element).opacity(0.75))
                                            .frame(width: geo.size.width * pct)
                                    }
                                    .frame(height: 6)
                                    .clipShape(RoundedRectangle(cornerRadius: 2))
                                }
                                .frame(height: 6)

                                Text("\(Int(pct * 100))%")
                                    .font(.system(size: 10, weight: .light, design: .monospaced))
                                    .foregroundStyle(Color.textTertiary)
                                    .frame(width: 30, alignment: .trailing)
                            }
                        }
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.bottom, Spacing.lg)

                // Dominant element
                FortunaCard(padding: Spacing.md, tint: Color.sajuTint) {
                    HStack(spacing: Spacing.md) {
                        Image(systemName: chart.dominantElement.symbolName)
                            .font(.system(size: 28, weight: .ultraLight))
                            .foregroundStyle(elementColor(chart.dominantElement))
                            .frame(width: 44)

                        VStack(alignment: .leading, spacing: 3) {
                            Text("Dominant Element")
                                .font(FortunaFont.caption(10))
                                .foregroundStyle(Color.textTertiary)
                                .tracking(1)
                            Text(chart.dominantElement.englishName)
                                .font(FortunaFont.display(22))
                                .foregroundStyle(Color.textPrimary)
                            Text(chart.dominantElement.rawValue + " · " + chart.dominantElement.koreanName)
                                .font(FortunaFont.caption(12))
                                .foregroundStyle(Color.textSecondary)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.bottom, Spacing.lg)

                // Period picker
                FortunaPicker(labels: ["Daily", "Monthly", "Yearly"], selected: $selectedPeriod)
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.bottom, Spacing.lg)

                // Fortune reading
                FortunaCard(padding: Spacing.lg, tint: Color.sajuTint) {
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "seal")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.accentGold)
                            Text(["Daily Reading", "Monthly Reading", "Yearly Reading"][selectedPeriod])
                                .font(FortunaFont.caption(11))
                                .foregroundStyle(Color.accentGold)
                                .tracking(1.5)
                            Spacer()
                        }

                        Text(fortuneText)
                            .font(FortunaFont.body(14))
                            .foregroundStyle(Color.textSecondary)
                            .lineSpacing(6)
                            .fixedSize(horizontal: false, vertical: true)
                            .id(selectedPeriod)
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.bottom, Spacing.lg)

                Button {
                    withAnimation(.spring(response: 0.5)) { viewModel.clearChart() }
                } label: {
                    Text("Recalculate with different birth data")
                        .font(FortunaFont.caption(12))
                        .foregroundStyle(Color.textTertiary)
                        .underline()
                }
                .buttonStyle(.plain)
                .padding(.horizontal, Spacing.screenHorizontal)

                Spacer(minLength: 120)
            }
        }
    }

    private func elementColor(_ element: FiveElement) -> Color {
        switch element {
        case .wood:  return Color.sajuTint
        case .fire:  return Color(hex: "C05050")
        case .earth: return Color(hex: "B89060")
        case .metal: return Color.textSecondary
        case .water: return Color.astrologyTint
        }
    }
}

#Preview {
    SajuView()
        .preferredColorScheme(.dark)
}
