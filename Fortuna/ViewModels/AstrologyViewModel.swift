import SwiftUI
import Combine

class AstrologyViewModel: ObservableObject {
    @Published var birthDate: Date? = nil
    @Published var userSign: ZodiacSign? = nil
    @Published var dailyFortune: String = ""
    @Published var monthlyFortune: String = ""
    @Published var yearlyFortune: String = ""
    @Published var showDatePicker = false

    private let birthDateKey = "fortuna.birthDate"

    init() {
        loadBirthDate()
    }

    var hasBirthDate: Bool { birthDate != nil }

    func setBirthDate(_ date: Date) {
        birthDate = date
        UserDefaults.standard.set(date, forKey: birthDateKey)
        computeFortunes()
    }

    private func loadBirthDate() {
        if let saved = UserDefaults.standard.object(forKey: birthDateKey) as? Date {
            birthDate = saved
            computeFortunes()
        }
    }

    private func computeFortunes() {
        guard let date = birthDate else { return }
        let sign = AstrologyService.zodiacSign(for: date)
        userSign = sign
        dailyFortune = AstrologyService.dailyFortune(for: sign)
        monthlyFortune = AstrologyService.monthlyFortune(for: sign)
        yearlyFortune = AstrologyService.yearlyFortune(for: sign)
    }

    func clearBirthDate() {
        birthDate = nil
        userSign = nil
        UserDefaults.standard.removeObject(forKey: birthDateKey)
    }
}
