import SwiftUI

// MARK: - Two-Hour Period (시진) Picker

struct HourPeriodPicker: View {
    @Binding var selectedHour: Int

    private let periods: [(name: String, chinese: String, hours: ClosedRange<Int>)] = [
        ("자시", "子", 23...23),
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
                    VStack(spacing: 4) {
                        Text(periods[i].chinese)
                            .font(.system(size: 22, weight: .ultraLight))
                            .foregroundStyle(isSelected ? Color.accentGold : Color.textSecondary)
                        Text(periods[i].name)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundStyle(isSelected ? Color.accentGold : Color.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .strokeBorder(
                                        isSelected ? Color.accentGold.opacity(0.5) : Color.white.opacity(0.06),
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
    @State private var birthHour = 11

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

                Text("The four pillars encode the cosmic configuration at the exact moment of your birth.")
                    .font(.system(size: 17, weight: .light))
                    .lineSpacing(7)
                    .foregroundStyle(Color.textSecondary)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 32)

                // Decorative stems
                HStack(spacing: Spacing.lg) {
                    ForEach(["甲", "乙", "丙", "丁", "戊"], id: \.self) { char in
                        Text(char)
                            .font(.system(size: 28, weight: .ultraLight))
                            .foregroundStyle(Color.textTertiary.opacity(0.4))
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 32)

                // Birth date card
                VStack(alignment: .leading, spacing: 20) {
                    Text("BIRTH DATE")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(3.0)
                        .foregroundStyle(Color.textTertiary)

                    DatePicker("", selection: $birthDate, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .colorScheme(.dark)
                        .tint(Color.accentGold)
                        .labelsHidden()
                }
                .padding(24)
                .fortGlass(cornerRadius: 24, tint: Color.sajuTint.opacity(0.06))
                .padding(.horizontal, 20)
                .padding(.bottom, 16)

                // Birth hour card
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("BIRTH HOUR  ·  시주")
                            .font(.system(size: 11, weight: .medium))
                            .tracking(3.0)
                            .foregroundStyle(Color.textTertiary)
                        Text("Each 시진 (two-hour period) determines your Hour Pillar.")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(Color.textTertiary)
                            .lineSpacing(3)
                    }

                    HourPeriodPicker(selectedHour: $birthHour)
                }
                .padding(24)
                .fortGlass(cornerRadius: 24, tint: Color.sajuTint.opacity(0.06))
                .padding(.horizontal, 20)
                .padding(.bottom, 32)

                // Calculate button
                Button {
                    withAnimation(.spring(response: 0.5)) {
                        viewModel.generateChart(birthDate: birthDate, birthHour: birthHour)
                    }
                } label: {
                    Text("Calculate My Four Pillars")
                        .font(.system(size: 17, weight: .medium))
                        .tracking(0.3)
                        .foregroundStyle(Color.appBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.accentGold)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding(.horizontal, 28)

                Spacer(minLength: 40)
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
