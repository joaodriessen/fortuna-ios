import Foundation

// MARK: - Seeded RNG

struct SeededRandom {
    private var state: UInt64

    init(seed: Int) {
        state = UInt64(bitPattern: Int64(seed &* 6364136223846793005 &+ 1442695040888963407))
        if state == 0 { state = 1 }
    }

    mutating func next() -> Int {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return Int(state >> 33)
    }

    mutating func nextInt(in range: Int) -> Int {
        guard range > 0 else { return 0 }
        return abs(next()) % range
    }
}

// MARK: - TarotService

class TarotService: @unchecked Sendable {
    static let shared = TarotService()

    let allCards: [TarotCard] = TarotCard.deck

    private init() {}

    func dailyCard() -> TarotCard {
        let dayHash = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return allCards[dayHash % allCards.count]
    }

    func monthlySpread() -> [TarotCard] {
        let components = Calendar.current.dateComponents([.month, .year], from: Date())
        let seed = (components.year ?? 2024) * 100 + (components.month ?? 1)
        var rng = SeededRandom(seed: seed)
        return drawCards(count: 3, using: &rng)
    }

    func yearlySpread() -> [TarotCard] {
        let year = Calendar.current.component(.year, from: Date())
        var rng = SeededRandom(seed: year * 13)
        return drawCards(count: 5, using: &rng)
    }

    private func drawCards(count: Int, using rng: inout SeededRandom) -> [TarotCard] {
        var indices = Array(0..<allCards.count)
        for i in stride(from: indices.count - 1, through: 1, by: -1) {
            let j = rng.nextInt(in: i) + 1
            if j < indices.count {
                indices.swapAt(i, j)
            }
        }
        return Array(indices.prefix(count)).map { allCards[$0] }
    }
}
