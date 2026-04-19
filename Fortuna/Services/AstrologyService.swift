import Foundation

class AstrologyService: @unchecked Sendable {
    static let shared = AstrologyService()
    private init() {}

    static func zodiacSign(for date: Date) -> ZodiacSign {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        switch (month, day) {
        case (3, 21...), (4, ...19): return ZodiacData.aries
        case (4, 20...), (5, ...20): return ZodiacData.taurus
        case (5, 21...), (6, ...20): return ZodiacData.gemini
        case (6, 21...), (7, ...22): return ZodiacData.cancer
        case (7, 23...), (8, ...22): return ZodiacData.leo
        case (8, 23...), (9, ...22): return ZodiacData.virgo
        case (9, 23...), (10, ...22): return ZodiacData.libra
        case (10, 23...), (11, ...21): return ZodiacData.scorpio
        case (11, 22...), (12, ...21): return ZodiacData.sagittarius
        case (12, 22...), (1, ...19): return ZodiacData.capricorn
        case (1, 20...), (2, ...18): return ZodiacData.aquarius
        default: return ZodiacData.pisces
        }
    }

    static func dailyFortune(for sign: ZodiacSign) -> String {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return sign.dailyFortunes[dayOfYear % sign.dailyFortunes.count]
    }

    static func monthlyFortune(for sign: ZodiacSign) -> String {
        let components = Calendar.current.dateComponents([.month, .year], from: Date())
        let seed = (components.year ?? 2024) * 100 + (components.month ?? 1)
        return sign.monthlyFortunes[seed % sign.monthlyFortunes.count]
    }

    static func yearlyFortune(for sign: ZodiacSign) -> String {
        let year = Calendar.current.component(.year, from: Date())
        return sign.yearlyFortunes[year % sign.yearlyFortunes.count]
    }
}
