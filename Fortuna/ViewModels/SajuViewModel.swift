import SwiftUI
import Combine

class SajuViewModel: ObservableObject {
    @Published var birthDate: Date? = nil
    @Published var birthHour: Int = 12
    @Published var chart: SajuChart? = nil
    @Published var dailyFortune: String = ""
    @Published var monthlyFortune: String = ""
    @Published var yearlyFortune: String = ""

    private let birthDateKey = "fortuna.sajuBirthDate"
    private let birthHourKey = "fortuna.sajuBirthHour"

    init() {
        loadSavedData()
    }

    var hasChart: Bool { chart != nil }

    func generateChart(birthDate: Date, birthHour: Int) {
        self.birthDate = birthDate
        self.birthHour = birthHour
        UserDefaults.standard.set(birthDate, forKey: birthDateKey)
        UserDefaults.standard.set(birthHour, forKey: birthHourKey)
        computeChart()
    }

    private func loadSavedData() {
        if let saved = UserDefaults.standard.object(forKey: birthDateKey) as? Date {
            birthDate = saved
            birthHour = UserDefaults.standard.integer(forKey: birthHourKey)
            if birthHour == 0 { birthHour = 12 }
            computeChart()
        }
    }

    private func computeChart() {
        guard let date = birthDate else { return }
        let computed = SajuService.chart(birthDate: date, birthHour: birthHour)
        chart = computed
        dailyFortune = SajuService.fortuneText(for: computed, period: .daily)
        monthlyFortune = SajuService.fortuneText(for: computed, period: .monthly)
        yearlyFortune = SajuService.fortuneText(for: computed, period: .yearly)
    }

    func clearChart() {
        birthDate = nil
        chart = nil
        UserDefaults.standard.removeObject(forKey: birthDateKey)
        UserDefaults.standard.removeObject(forKey: birthHourKey)
    }

    var pillarLabels: [String] { ["Year\n년주", "Month\n월주", "Day\n일주", "Hour\n시주"] }
}
