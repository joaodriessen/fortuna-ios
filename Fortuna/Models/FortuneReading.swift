import Foundation

struct FortuneReading: Identifiable {
    let id = UUID()
    let title: String
    let body: String
    let date: Date
    let category: FortuneCategory
}

enum FortuneCategory: String {
    case daily = "Daily"
    case monthly = "Monthly"
    case yearly = "Yearly"
}
