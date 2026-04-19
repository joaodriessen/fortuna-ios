import SwiftUI

// MARK: - 시진 (Two-Hour Period) Picker

struct HourPeriodPicker: View {
    @Binding var selectedHour: Int

    // 12 두-hour periods (시진) with their branch, Korean name, and a representative hour
    private let periods: [(name: String, chinese: String, hours: ClosedRange<Int>)] = [
        ("자시", "子", 23...23),  // 23:00-01:00 → represented as 0
        ("축시", "丑", 1...2),
        ("인시", "寅", 3...4),
        ("묘시", "卯", 5...6),
        ("진시", "辰", 7...8),
        ("사시", "巳", 9...10),
        ("오시", "午", 11...12),
        ("미시", "未", 13...14),
        ("신시", "申", 15...16),
        ("유시", "酉", 17...18),
        ("술시", "戌", 19...20),
        ("해시", "亥", 21...22)
    ]

    // Representative hour for each period (used for calculation)
    private let representativeHours = [0, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21]

    private func periodIndex(for hour: Int) -> Int {
        if hour == 23 { return 0 }
        return (hour + 1) / 2
    }

    private var selectedIdx: Int { periodIndex(for: selectedHour) }

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
            ForEach(periods.indices, id: \.self) { i in
                let isSelected = selectedIdx == i
                Button {
                    selectedHour = representativeHours[i]
                } label: {
                    VStack(spacing: 3) {
                        Text(periods[i].chinese)
                            .font(.system(size: 18, weight: .ultraLight, design: .default))
                            .foregroundStyle(isSelected ? Color.accentGold : Color.textSecondary)
                        Text(periods[i].name)
                            .font(FortunaFont.caption(9))
                            .foregroundStyle(isSelected ? Color.accentGold : Color.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isSelected ? Color.accentGold.opacity(0.12) : Color.surfaceRaised)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(
                                        isSelected ? Color.accentGold.opacity(0.4) : Color.clear,
                                        lineWidth: 0.5
                                    )
                            }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Saju Input View

struct SajuInputView: View {
    @ObservedObject var viewModel: SajuViewModel
    @State private var birthDate = Date()
    @State private var birthHour = 11  // Default: 오시 (midday)

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

                Text("The four pillars encode the cosmic configuration at the exact moment of your birth.")
                    .font(FortunaFont.body(15))
                    .foregroundStyle(Color.textSecondary)
                    .lineSpacing(5)
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.bottom, Spacing.xl)

                // Decorative stems
                HStack(spacing: Spacing.lg) {
                    ForEach(["甲", "乙", "丙", "丁", "戊"], id: \.self) { char in
                        Text(char)
                            .font(.system(size: 20, weight: .ultraLight))
                            .foregroundStyle(Color.textTertiary.opacity(0.4))
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.bottom, Spacing.xl)

                // Birth date card
                FortunaCard(padding: Spacing.lg, tint: Color.sajuTint) {
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        Text("Birth Date")
                            .font(FortunaFont.caption(11))
                            .foregroundStyle(Color.accentGold)
                            .tracking(2)

                        DatePicker("", selection: $birthDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .colorScheme(.dark)
                            .tint(Color.accentGold)
                            .labelsHidden()
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.bottom, Spacing.md)

                // Birth hour card
                FortunaCard(padding: Spacing.lg, tint: Color.sajuTint) {
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Birth Hour · 시주")
                                .font(FortunaFont.caption(11))
                                .foregroundStyle(Color.accentGold)
                                .tracking(2)
                            Text("Each 시진 (two-hour period) determines your Hour Pillar and governs your inner life.")
                                .font(FortunaFont.caption(11))
                                .foregroundStyle(Color.textTertiary)
                                .lineSpacing(3)
                        }

                        HourPeriodPicker(selectedHour: $birthHour)
                    }
                }
                .padding(.horizontal, Spacing.screenHorizontal)
                .padding(.bottom, Spacing.xl)

                // Calculate button
                Button {
                    withAnimation(.spring(response: 0.5)) {
                        viewModel.generateChart(birthDate: birthDate, birthHour: birthHour)
                    }
                } label: {
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "seal")
                        Text("Calculate My Four Pillars")
                            .font(FortunaFont.displayMedium(15))
                    }
                    .foregroundStyle(Color.appBackground)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.accentGold)
                    }
                }
                .buttonStyle(.plain)
                .padding(.horizontal, Spacing.screenHorizontal)

                Spacer(minLength: 120)
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
