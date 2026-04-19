import SwiftUI

struct AstrologyView: View {
    @StateObject private var vm = AstrologyViewModel()
    @State private var selectedPeriod: FortunePeriod = .daily
    @Namespace private var ns

    var body: some View {
        ZStack {
            CosmicBackground()

            if !vm.hasBirthDate {
                AstrologyOnboardingView(vm: vm)
            } else if let sign = vm.userSign {
                AstrologyReadingView(vm: vm, sign: sign, selectedPeriod: $selectedPeriod, ns: ns)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: vm.hasBirthDate)
    }
}

// MARK: - Onboarding

struct AstrologyOnboardingView: View {
    @ObservedObject var vm: AstrologyViewModel
    @State private var tempDate: Date = Date()

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Text("✦")
                .font(.system(size: 80, weight: .ultraLight))
                .foregroundStyle(Color.accentGold.opacity(0.6))
                .padding(.bottom, 32)

            Text("When were you born?")
                .font(.system(size: 36, weight: .ultraLight))
                .tracking(-0.3)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)

            Text("Your birth date reveals your cosmic blueprint.")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 48)

            VStack(spacing: 0) {
                DatePicker(
                    "",
                    selection: $tempDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .colorScheme(.dark)
            }
            .padding(.vertical, 8)
            .fortGlass(cornerRadius: 24)
            .padding(.horizontal, 28)
            .padding(.bottom, 32)

            Button {
                withAnimation(.spring(response: 0.5)) {
                    vm.setBirthDate(tempDate)
                }
            } label: {
                Text("Reveal My Stars")
                    .font(.system(size: 17, weight: .medium))
                    .tracking(0.3)
                    .foregroundStyle(Color.appBackground)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.accentGold)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 28)

            Spacer()
        }
    }
}

// MARK: - Reading View

struct AstrologyReadingView: View {
    @ObservedObject var vm: AstrologyViewModel
    let sign: ZodiacSign
    @Binding var selectedPeriod: FortunePeriod
    let ns: Namespace.ID

    private var fortuneText: String {
        switch selectedPeriod {
        case .daily:   return vm.dailyFortune
        case .monthly: return vm.monthlyFortune
        case .yearly:  return vm.yearlyFortune
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                // HERO
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [sign.element.glowColor.opacity(0.25), .clear],
                                center: .center, startRadius: 0, endRadius: 140
                            )
                        )
                        .frame(width: 280, height: 280)
                        .blur(radius: 20)

                    VStack(spacing: 20) {
                        Text(sign.symbol)
                            .font(.system(size: 120, weight: .ultraLight))
                            .foregroundStyle(Color.textPrimary)
                            .shadow(color: sign.element.glowColor.opacity(0.5), radius: 30)

                        Text(sign.name.uppercased())
                            .font(.system(size: 48, weight: .ultraLight))
                            .tracking(6.0)
                            .foregroundStyle(Color.textPrimary)

                        Text("\(sign.element.rawValue.uppercased())  ·  \(sign.rulingPlanet.uppercased())")
                            .font(.system(size: 12, weight: .regular))
                            .tracking(3.0)
                            .foregroundStyle(Color.accentGold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
                .padding(.bottom, 48)

                // PERIOD PICKER
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
                                            .matchedGeometryEffect(id: "astroPill", in: ns)
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 36)

                // FORTUNE PANEL
                VStack(alignment: .leading, spacing: 20) {
                    Text(selectedPeriod.label.uppercased() + " READING")
                        .font(.system(size: 11, weight: .medium))
                        .tracking(3.0)
                        .foregroundStyle(sign.element.glowColor.opacity(0.8))

                    Text(fortuneText)
                        .font(.system(size: 20, weight: .light))
                        .lineSpacing(10)
                        .foregroundStyle(Color.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(28)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fortGlass(cornerRadius: 28, tint: sign.element.glowColor.opacity(0.06))
                .padding(.horizontal, 20)
                .padding(.bottom, 24)

                // SIGN TRAITS
                VStack(alignment: .leading, spacing: 24) {
                    SignTraitRow(label: "TRAITS", value: sign.traits.joined(separator: "  ·  "))
                    Divider().overlay(Color.white.opacity(0.08))
                    SignTraitRow(label: "DATE RANGE", value: sign.dateRange)
                    Divider().overlay(Color.white.opacity(0.08))
                    SignTraitRow(label: "ELEMENT", value: sign.element.rawValue)
                    Divider().overlay(Color.white.opacity(0.08))
                    SignTraitRow(label: "RULING PLANET", value: sign.rulingPlanet)
                }
                .padding(28)
                .fortGlass(cornerRadius: 28)
                .padding(.horizontal, 20)
                .padding(.bottom, 24)

                // CHANGE DATE
                Button {
                    vm.clearBirthDate()
                } label: {
                    Text("Change birth date")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.textTertiary)
                        .padding(.vertical, 8)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Sign Trait Row

struct SignTraitRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .tracking(2.5)
                .foregroundStyle(Color.textTertiary)
            Text(value)
                .font(.system(size: 16, weight: .light))
                .foregroundStyle(Color.textPrimary)
        }
    }
}

// MARK: - Element Glow Color

extension CosmicElement {
    var glowColor: Color {
        switch self {
        case .fire:  return Color(hex: "E8714A")   // warm amber-red
        case .earth: return Color(hex: "7BA05B")   // sage
        case .air:   return Color(hex: "9DB4D4")   // pale steel
        case .water: return Color(hex: "4A85B5")   // deep blue
        }
    }
}

// MARK: - FortunePeriod Equatable

extension FortunePeriod: Equatable {
    public static func == (lhs: FortunePeriod, rhs: FortunePeriod) -> Bool {
        lhs.label == rhs.label
    }
}

#Preview {
    AstrologyView()
        .preferredColorScheme(.dark)
}
