import SwiftUI

struct AstrologyView: View {
    @StateObject private var viewModel = AstrologyViewModel()
    @State private var selectedPeriod = 0

    var body: some View {
        ZStack {
            CosmicBackground()

            if viewModel.hasBirthDate, let sign = viewModel.userSign {
                AstrologyReadingView(viewModel: viewModel, sign: sign, selectedPeriod: $selectedPeriod)
            } else {
                AstrologyOnboardingView(viewModel: viewModel)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Onboarding

struct AstrologyOnboardingView: View {
    @ObservedObject var viewModel: AstrologyViewModel
    @State private var birthDate = Date()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Astrology")
                        .font(FortunaFont.display(34))
                        .foregroundStyle(Color.textPrimary)
                    Text("Read your celestial blueprint")
                        .font(FortunaFont.caption(13))
                        .foregroundStyle(Color.textTertiary)
                }
                .padding(.top, 64)
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.bottom, Spacing.xl)

                // Decorative sign row
                HStack(spacing: Spacing.lg) {
                    ForEach(ZodiacData.allSigns.prefix(6), id: \.name) { sign in
                        Text(sign.symbol)
                            .font(.system(size: 18, weight: .ultraLight))
                            .foregroundStyle(Color.textTertiary.opacity(0.6))
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.bottom, Spacing.xl)

                Text("The stars have been studying you\nsince the moment you arrived.")
                    .font(FortunaFont.display(19))
                    .foregroundStyle(Color.textSecondary)
                    .lineSpacing(6)
                    .italic()
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.bottom, Spacing.xxl)

                FortunaCard(padding: Spacing.lg, tint: Color.astrologyTint) {
                    VStack(spacing: Spacing.lg) {
                        Text("Your Birth Date")
                            .font(FortunaFont.caption(11))
                            .foregroundStyle(Color.accentGold)
                            .tracking(2)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        DatePicker("", selection: $birthDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .colorScheme(.dark)
                            .tint(Color.accentGold)
                            .labelsHidden()

                        Button {
                            withAnimation(.spring(response: 0.5)) {
                                viewModel.setBirthDate(birthDate)
                            }
                        } label: {
                            HStack(spacing: Spacing.xs) {
                                Image(systemName: "sparkles")
                                Text("Reveal My Sign")
                                    .font(FortunaFont.displayMedium(15))
                            }
                            .foregroundStyle(Color.appBackground)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.accentGold)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)

                Spacer(minLength: 120)
            }
        }
    }
}

// MARK: - Reading View

struct AstrologyReadingView: View {
    @ObservedObject var viewModel: AstrologyViewModel
    let sign: ZodiacSign
    @Binding var selectedPeriod: Int

    private var fortuneText: String {
        [viewModel.dailyFortune, viewModel.monthlyFortune, viewModel.yearlyFortune][selectedPeriod]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Astrology")
                        .font(FortunaFont.display(34))
                        .foregroundStyle(Color.textPrimary)
                    Text(sign.dateRange)
                        .font(FortunaFont.caption(12))
                        .foregroundStyle(Color.textTertiary)
                        .tracking(1)
                }
                .padding(.top, 64)
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.bottom, Spacing.xl)

                // Wheel
                ZodiacWheelView(userSign: sign)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, Spacing.lg)

                // Sign info card
                FortunaCard(padding: Spacing.md, tint: Color.astrologyTint) {
                    HStack(spacing: Spacing.md) {
                        VStack(spacing: 4) {
                            Text(sign.symbol)
                                .font(.system(size: 42, weight: .ultraLight))
                                .foregroundStyle(Color.accentGold)
                            Text(sign.name.uppercased())
                                .font(FortunaFont.caption(9))
                                .foregroundStyle(Color.accentGold)
                                .tracking(2)
                        }

                        Rectangle()
                            .fill(Color.divider)
                            .frame(width: 0.5)
                            .padding(.vertical, 4)

                        VStack(alignment: .leading, spacing: 6) {
                            InfoRow(label: "Element", value: sign.element.rawValue)
                            InfoRow(label: "Ruler",   value: sign.rulingPlanet)
                            InfoRow(label: "Traits",  value: sign.traits.prefix(3).joined(separator: ", "))
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

                // Fortune card
                FortunaCard(padding: Spacing.lg, tint: Color.astrologyTint) {
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "moon.stars")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.accentGold)
                            Text(["Daily Fortune", "Monthly Fortune", "Yearly Fortune"][selectedPeriod])
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
                    viewModel.clearBirthDate()
                } label: {
                    Text("Change birth date")
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
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 5) {
            Text(label + ":")
                .font(FortunaFont.caption(10))
                .foregroundStyle(Color.textTertiary)
            Text(value)
                .font(FortunaFont.caption(11))
                .foregroundStyle(Color.textSecondary)
        }
    }
}

#Preview {
    AstrologyView()
        .preferredColorScheme(.dark)
}
