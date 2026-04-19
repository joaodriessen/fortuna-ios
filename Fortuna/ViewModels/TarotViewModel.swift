import SwiftUI
import Combine

class TarotViewModel: ObservableObject {
    @Published var dailyCard: TarotCard
    @Published var monthlySpread: [TarotCard]
    @Published var yearlySpread: [TarotCard]
    @Published var isCardFlipped = false
    @Published var selectedCard: TarotCard?

    private let service = TarotService.shared
    private let flipKey = "fortuna.tarot.flippedDate"

    init() {
        dailyCard = service.dailyCard()
        monthlySpread = service.monthlySpread()
        yearlySpread = service.yearlySpread()
        checkFlipState()
    }

    var hasFlippedToday: Bool {
        guard let lastFlipDate = UserDefaults.standard.object(forKey: flipKey) as? Date else {
            return false
        }
        return Calendar.current.isDateInToday(lastFlipDate)
    }

    func flipCard() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isCardFlipped = true
        }
        UserDefaults.standard.set(Date(), forKey: flipKey)
    }

    private func checkFlipState() {
        isCardFlipped = hasFlippedToday
    }

    func spreadLabel(for index: Int, spreadType: SpreadType) -> String {
        switch spreadType {
        case .monthly:
            return ["Past", "Present", "Future"][index]
        case .yearly:
            return ["Foundation", "Present", "Future", "Strength", "Outcome"][index]
        }
    }

    enum SpreadType { case monthly, yearly }
}
