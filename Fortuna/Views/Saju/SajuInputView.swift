import SwiftUI

struct SajuInputView: View {
    @ObservedObject var viewModel: SajuViewModel
    @State private var birthDate = Date()
    @State private var birthHour = 12

    private let hours = Array(0..<24)

    var hourLabel: String {
        let h = birthHour
        let suffix = h < 12 ? "AM" : "PM"
        let display = h == 0 ? 12 : (h > 12 ? h - 12 : h)
        return String(format: "%d:00 %@", display, suffix)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 8) {
                    Text("사주팔자")
                        .font(.system(size: 36, weight: .thin, design: .serif))
                        .foregroundStyle(.celestialGold)
                        .shimmer()
                    Text("SAJU — FOUR PILLARS OF DESTINY")
                        .font(.system(size: 10, weight: .light))
                        .foregroundStyle(.starWhite.opacity(0.5))
                        .tracking(3)
                }
                .padding(.top, 70)

                // Intro text
                Text("The Four Pillars encode the cosmic configuration at the moment of your birth. Every pillar, every stem, every branch carries a reading of your path.")
                    .font(.system(size: 14, weight: .light, design: .serif))
                    .foregroundStyle(.starWhite.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .italic()
                    .padding(.horizontal, 40)

                // Decorative characters
                HStack(spacing: 24) {
                    ForEach(["甲", "乙", "丙", "丁", "戊"], id: \.self) { char in
                        Text(char)
                            .font(.system(size: 22, weight: .thin, design: .serif))
                            .foregroundStyle(.celestialGold.opacity(0.25))
                    }
                }

                // Input form
                GlassCard {
                    VStack(spacing: 24) {
                        // Birth date
                        VStack(spacing: 8) {
                            Text("Birth Date")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.celestialGold)
                                .tracking(2)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            DatePicker("", selection: $birthDate, displayedComponents: .date)
                                .datePickerStyle(.wheel)
                                .colorScheme(.dark)
                                .tint(.celestialGold)
                                .labelsHidden()
                        }

                        Divider().background(.white.opacity(0.1))

                        // Birth hour
                        VStack(spacing: 12) {
                            Text("Birth Hour")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.celestialGold)
                                .tracking(2)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text(hourLabel)
                                .font(.system(size: 28, weight: .thin, design: .serif))
                                .foregroundStyle(.starWhite)

                            Slider(value: Binding(
                                get: { Double(birthHour) },
                                set: { birthHour = Int($0) }
                            ), in: 0...23, step: 1)
                            .tint(.celestialGold)

                            HStack {
                                Text("Midnight")
                                    .font(.caption2)
                                    .foregroundStyle(.starWhite.opacity(0.3))
                                Spacer()
                                Text("Noon")
                                    .font(.caption2)
                                    .foregroundStyle(.starWhite.opacity(0.3))
                                Spacer()
                                Text("Midnight")
                                    .font(.caption2)
                                    .foregroundStyle(.starWhite.opacity(0.3))
                            }

                            Text("The hour of birth determines your Hour Pillar (시주),\nwhich governs your inner self and later years.")
                                .font(.system(size: 10, weight: .light))
                                .foregroundStyle(.starWhite.opacity(0.4))
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                        }

                        // Generate button
                        Button {
                            withAnimation(.spring(response: 0.5)) {
                                viewModel.generateChart(birthDate: birthDate, birthHour: birthHour)
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "yin.yang")
                                Text("Calculate My Four Pillars")
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
                .padding(.horizontal, 20)

                Spacer(minLength: 100)
            }
        }
    }
}

#Preview {
    ZStack {
        CosmicBackground()
        SajuInputView(viewModel: SajuViewModel())
    }
    .preferredColorScheme(.dark)
}
