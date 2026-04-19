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
        .animation(.easeInOut(duration: 0.4), value: viewModel.hasChart)
    }
}

// MARK: - Result View

struct SajuResultView: View {
    @ObservedObject var viewModel: SajuViewModel
    let chart: SajuChart
    @State private var selectedPeriod: FortunePeriod = .daily
    @State private var pillarsAppeared = false
    @Namespace private var ns

    private var fortuneText: String {
        switch selectedPeriod {
        case .daily:   return viewModel.dailyFortune
        case .monthly: return viewModel.monthlyFortune
        case .yearly:  return viewModel.yearlyFortune
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("SAJU")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(3.0)
                        .foregroundStyle(Color.textTertiary)

                    Text("사주팔자")
                        .font(.system(size: 42, weight: .ultraLight))
                        .foregroundStyle(Color.textPrimary)

                    Text("Four Pillars of Destiny")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Color.textSecondary)
                        .tracking(1)
                }
                .padding(.top, 24)
                .padding(.horizontal, 28)
                .padding(.bottom, 36)

                // Four Pillars — 2x2 grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    PillarCard(label: "년주  YEAR", pillar: chart.yearPillar)
                        .opacity(pillarsAppeared ? 1 : 0)
                        .offset(y: pillarsAppeared ? 0 : 12)
                        .animation(.spring(response: 0.5).delay(0.05), value: pillarsAppeared)
                    PillarCard(label: "월주  MONTH", pillar: chart.monthPillar)
                        .opacity(pillarsAppeared ? 1 : 0)
                        .offset(y: pillarsAppeared ? 0 : 12)
                        .animation(.spring(response: 0.5).delay(0.10), value: pillarsAppeared)
                    PillarCard(label: "일주  DAY", pillar: chart.dayPillar)
                        .opacity(pillarsAppeared ? 1 : 0)
                        .offset(y: pillarsAppeared ? 0 : 12)
                        .animation(.spring(response: 0.5).delay(0.15), value: pillarsAppeared)
                    PillarCard(label: "시주  HOUR", pillar: chart.hourPillar)
                        .opacity(pillarsAppeared ? 1 : 0)
                        .offset(y: pillarsAppeared ? 0 : 12)
                        .animation(.spring(response: 0.5).delay(0.20), value: pillarsAppeared)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .onAppear { pillarsAppeared = true }

                // Five elements bars
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("FIVE ELEMENTS  ·  오행")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(3.0)
                        .foregroundStyle(Color.textTertiary)

                    ForEach(FiveElement.allCases, id: \.self) { element in
                        let pct = chart.elementPercentages[element] ?? 0
                        HStack(spacing: Spacing.sm) {
                            Image(systemName: element.symbolName)
                                .font(.system(size: 13))
                                .foregroundStyle(elementColor(element))
                                .frame(width: 18)

                            Text(element.englishName)
                                .font(.system(size: 13, weight: .regular))
                                .foregroundStyle(Color.textSecondary)
                                .frame(width: 48, alignment: .leading)

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.white.opacity(0.06))
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(elementColor(element).opacity(0.75))
                                        .frame(width: geo.size.width * pct)
                                }
                                .frame(height: 6)
                                .clipShape(RoundedRectangle(cornerRadius: 2))
                            }
                            .frame(height: 6)

                            Text("\(Int(pct * 100))%")
                                .font(.system(size: 11, weight: .light, design: .monospaced))
                                .foregroundStyle(Color.textTertiary)
                                .frame(width: 30, alignment: .trailing)
                        }
                    }
                }
                .padding(28)
                .fortGlass(cornerRadius: 28, tint: Color.sajuTint.opacity(0.06))
                .padding(.horizontal, 20)
                .padding(.bottom, 24)

                // Dominant element
                HStack(spacing: 20) {
                    Image(systemName: chart.dominantElement.symbolName)
                        .font(.system(size: 32, weight: .ultraLight))
                        .foregroundStyle(elementColor(chart.dominantElement))
                        .frame(width: 52)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("DOMINANT ELEMENT")
                            .font(.system(size: 11, weight: .medium))
                            .tracking(2.5)
                            .foregroundStyle(Color.textTertiary)
                        Text(chart.dominantElement.englishName)
                            .font(.system(size: 28, weight: .ultraLight))
                            .foregroundStyle(Color.textPrimary)
                        Text(chart.dominantElement.rawValue + "  ·  " + chart.dominantElement.koreanName)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(Color.textSecondary)
                    }
                    Spacer()
                }
                .padding(24)
                .fortGlass(cornerRadius: 24, tint: elementColor(chart.dominantElement).opacity(0.05))
                .padding(.horizontal, 20)
                .padding(.bottom, 24)

                // Period picker — glass pill style
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
                                            .matchedGeometryEffect(id: "sajuPill", in: ns)
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 24)

                // Fortune reading
                VStack(alignment: .leading, spacing: 20) {
                    Text(selectedPeriod.label.uppercased() + " READING")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(3.0)
                        .foregroundStyle(Color.sajuTint.opacity(0.8))

                    Text(fortuneText)
                        .font(.system(size: 20, weight: .light))
                        .lineSpacing(10)
                        .foregroundStyle(Color.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                        .id(selectedPeriod.label)
                }
                .padding(28)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fortGlass(cornerRadius: 28, tint: Color.sajuTint.opacity(0.06))
                .padding(.horizontal, 20)
                .padding(.bottom, 24)

                Button {
                    withAnimation(.spring(response: 0.5)) { viewModel.clearChart() }
                } label: {
                    Text("Recalculate with different birth data")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.textTertiary)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 28)
                .padding(.bottom, 40)
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

// MARK: - Pillar Card

struct PillarCard: View {
    let label: String
    let pillar: SajuPillar

    var body: some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .tracking(2.0)
                .foregroundStyle(Color.textTertiary)

            Text(pillar.stem.chineseName)
                .font(.system(size: 52, weight: .ultraLight))
                .foregroundStyle(Color.textPrimary)

            Text(pillar.branch.chineseName)
                .font(.system(size: 44, weight: .ultraLight))
                .foregroundStyle(Color.accentGold)

            Text(pillar.koreanDisplay)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .fortGlass(cornerRadius: 20, tint: Color.sajuTint.opacity(0.08))
    }
}

#Preview {
    SajuView()
        .preferredColorScheme(.dark)
}
