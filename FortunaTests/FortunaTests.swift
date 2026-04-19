import XCTest
@testable import Fortuna

final class FortunaTests: XCTestCase {

    // MARK: - Tarot Tests

    func testTarotDeckHas78Cards() {
        XCTAssertEqual(TarotCard.deck.count, 78)
    }

    func testTarotMajorArcanaHas22Cards() {
        let major = TarotCard.deck.filter { $0.arcana == .major }
        XCTAssertEqual(major.count, 22)
    }

    func testTarotMinorArcanaHas56Cards() {
        let minor = TarotCard.deck.filter { $0.arcana == .minor }
        XCTAssertEqual(minor.count, 56)
    }

    func testTarotEachSuitHas14Cards() {
        for suit in [Suit.wands, .cups, .swords, .pentacles] {
            let count = TarotCard.deck.filter { $0.suit == suit }.count
            XCTAssertEqual(count, 14, "Expected 14 cards for \(suit) but got \(count)")
        }
    }

    func testDailyCardIsDeterministic() {
        let service = TarotService.shared
        let card1 = service.dailyCard()
        let card2 = service.dailyCard()
        XCTAssertEqual(card1.id, card2.id)
    }

    func testMonthlySpreadHas3Cards() {
        let service = TarotService.shared
        XCTAssertEqual(service.monthlySpread().count, 3)
    }

    func testYearlySpreadHas5Cards() {
        let service = TarotService.shared
        XCTAssertEqual(service.yearlySpread().count, 5)
    }

    func testMonthlySpreadCardsAreUnique() {
        let spread = TarotService.shared.monthlySpread()
        let ids = spread.map { $0.id }
        XCTAssertEqual(Set(ids).count, ids.count)
    }

    // MARK: - Astrology Tests

    func testZodiacSignDetection() {
        let calendar = Calendar.current
        var comps = DateComponents()

        // Aries: March 21
        comps.year = 1990; comps.month = 3; comps.day = 25
        let ariesDate = calendar.date(from: comps)!
        XCTAssertEqual(AstrologyService.zodiacSign(for: ariesDate).name, "Aries")

        // Leo: August 5
        comps.month = 8; comps.day = 5
        let leoDate = calendar.date(from: comps)!
        XCTAssertEqual(AstrologyService.zodiacSign(for: leoDate).name, "Leo")

        // Scorpio: November 1
        comps.month = 11; comps.day = 1
        let scorpioDate = calendar.date(from: comps)!
        XCTAssertEqual(AstrologyService.zodiacSign(for: scorpioDate).name, "Scorpio")
    }

    func testAllSignsHaveFortunes() {
        for sign in ZodiacData.allSigns {
            XCTAssertFalse(sign.dailyFortunes.isEmpty, "\(sign.name) missing daily fortunes")
            XCTAssertFalse(sign.monthlyFortunes.isEmpty, "\(sign.name) missing monthly fortunes")
            XCTAssertFalse(sign.yearlyFortunes.isEmpty, "\(sign.name) missing yearly fortunes")
        }
    }

    // MARK: - Saju Tests

    func testSajuYearPillar2024() {
        let pillar = SajuService.yearPillar(year: 2024)
        // 2024 - 4 = 2020, 2020 % 10 = 0 (갑/Gab), 2020 % 12 = 8 (신/Monkey)
        XCTAssertEqual(pillar.stem.rawValue, 0)  // Gab
        XCTAssertEqual(pillar.branch.rawValue, 8) // Monkey (신)
    }

    func testSajuChartHasFourPillars() {
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.year = 1990; comps.month = 6; comps.day = 15
        let date = calendar.date(from: comps)!
        let chart = SajuService.chart(birthDate: date, birthHour: 10)
        XCTAssertEqual(chart.allPillars.count, 4)
    }

    func testSajuElementCountsNonNegative() {
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.year = 1985; comps.month = 3; comps.day = 20
        let date = calendar.date(from: comps)!
        let chart = SajuService.chart(birthDate: date, birthHour: 14)
        for (_, count) in chart.elementCounts {
            XCTAssertGreaterThanOrEqual(count, 0)
        }
    }

    func testDominantElementExists() {
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.year = 1992; comps.month = 9; comps.day = 8
        let date = calendar.date(from: comps)!
        let chart = SajuService.chart(birthDate: date, birthHour: 7)
        let _ = chart.dominantElement // Should not crash
    }

    func testSajuFortuneTextNonEmpty() {
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.year = 1995; comps.month = 12; comps.day = 1
        let date = calendar.date(from: comps)!
        let chart = SajuService.chart(birthDate: date, birthHour: 0)
        XCTAssertFalse(SajuService.fortuneText(for: chart, period: .daily).isEmpty)
        XCTAssertFalse(SajuService.fortuneText(for: chart, period: .monthly).isEmpty)
        XCTAssertFalse(SajuService.fortuneText(for: chart, period: .yearly).isEmpty)
    }

    // MARK: - SeededRandom Tests

    func testSeededRandomIsDeterministic() {
        var rng1 = SeededRandom(seed: 42)
        var rng2 = SeededRandom(seed: 42)
        for _ in 0..<100 {
            XCTAssertEqual(rng1.next(), rng2.next())
        }
    }
}
