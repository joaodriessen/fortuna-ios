import SwiftUI

struct AstrologyView: View {
    @StateObject private var viewModel = AstrologyViewModel()
    @State private var selectedPeriod = 0

    var body: some View {
        NavigationStack {
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
}

// MARK: - Onboarding

struct AstrologyOnboardingView: View {
    @ObservedObject var viewModel: AstrologyViewModel
    @State private var birthDate = Date()
    @State private var appeared = false

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text("ASTROLOGY")
                        .font(.system(size: 28, weight: .thin, design: .serif))
                        .tracking(10)
                        .foregroundStyle(.celestialGold)
                        .shimmer()
                    Text("Read The Stars")
                        .font(.system(size: 11, weight: .light))
                        .foregroundStyle(.starWhite.opacity(0.5))
                        .tracking(3)
                }
                .padding(.top, 70)

                // Zodiac symbols decorative row
                HStack(spacing: 16) {
                    ForEach(ZodiacData.allSigns.prefix(6), id: \.name) { sign in
                        Text(sign.symbol)
                            .font(.title3)
                            .foregroundStyle(.starWhite.opacity(0.3))
                    }
                }

                Text("The stars have been studying you\nsince the moment you arrived.")
                    .font(.system(size: 18, weight: .light, design: .serif))
                    .foregroundStyle(.starWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .italic()
                    .padding(.horizontal, 40)

                Text("Enter your birth date to reveal your cosmic blueprint.")
                    .font(.system(size: 13, weight: .light))
                    .foregroundStyle(.starWhite.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)

                GlassCard {
                    VStack(spacing: 20) {
                        Text("Your Birth Date")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.celestialGold)
                            .tracking(2)

                        DatePicker("", selection: $birthDate, displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .colorScheme(.dark)
                            .tint(.celestialGold)
                            .labelsHidden()

                        Button {
                            withAnimation(.spring(response: 0.5)) {
                                viewModel.setBirthDate(birthDate)
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "sparkles")
                                Text("Reveal My Sign")
                                    .font(.system(size: 15, weight: .medium))
                            }
                            .foregroundStyle(.cosmicBackground)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(.celestialGold)
                            }
                        }
                    }
                    .padding(24)
                }
                .padding(.horizontal, 24)

                Spacer(minLength: 100)
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
                VStack(spacing: 8) {
                    Text("ASTROLOGY")
                        .font(.system(size: 26, weight: .thin, design: .serif))
                        .tracking(10)
                        .foregroundStyle(.celestialGold)
                        .shimmer()

                    Text(sign.dateRange)
                        .font(.system(size: 11, weight: .light))
                        .foregroundStyle(.starWhite.opacity(0.5))
                        .tracking(2)
                }
                .padding(.top, 64)

                // Zodiac wheel
                ZodiacWheelView(userSign: sign)

                // Sign info card
                GlassCard {
                    HStack(spacing: 16) {
                        VStack(spacing: 4) {
                            Text(sign.symbol)
                                .font(.system(size: 44, weight: .thin))
                                .foregroundStyle(.celestialGold)
                            Text(sign.name.uppercased())
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.celestialGold)
                                .tracking(3)
                        }

                        Divider()
                            .background(.white.opacity(0.15))

                        VStack(alignment: .leading, spacing: 8) {
                            InfoRow(label: "Element", value: "\(sign.element.emoji) \(sign.element.rawValue)")
                            InfoRow(label: "Ruler", value: sign.rulingPlanet)
                            InfoRow(label: "Traits", value: sign.traits.prefix(3).joined(separator: ", "))
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

                // Fortune card
                GlassCard {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "moon.stars.fill")
                                .foregroundStyle(.celestialGold)
                            Text(["Daily Fortune", "Monthly Fortune", "Yearly Fortune"][selectedPeriod])
                                .font(.caption)
                                .foregroundStyle(.celestialGold)
                                .tracking(2)
                            Spacer()
                        }

                        Text(fortuneText)
                            .font(.system(size: 15, weight: .light, design: .serif))
                            .foregroundStyle(.starWhite.opacity(0.9))
                            .lineSpacing(6)
                            .id(selectedPeriod) // Force redraw on tab change
                    }
                    .padding(22)
                }
                .padding(.horizontal, 20)

                // Change birth date
                Button {
                    viewModel.clearBirthDate()
                } label: {
                    Text("Change birth date")
                        .font(.system(size: 12, weight: .light))
                        .foregroundStyle(.starWhite.opacity(0.35))
                        .underline()
                }

                Spacer(minLength: 100)
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 6) {
            Text(label + ":")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.starWhite.opacity(0.4))
            Text(value)
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.starWhite.opacity(0.8))
        }
    }
}

#Preview {
    AstrologyView()
        .preferredColorScheme(.dark)
}
