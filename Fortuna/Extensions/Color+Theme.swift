import SwiftUI

extension Color {
    static let cosmicBackground = Color(red: 0.04, green: 0.04, blue: 0.12)
    static let nebulaDeep = Color(red: 0.3, green: 0.1, blue: 0.6)
    static let nebulaGlow = Color(red: 0.5, green: 0.2, blue: 0.9)
    static let celestialGold = Color(red: 1.0, green: 0.82, blue: 0.25)
    static let starWhite = Color(red: 0.95, green: 0.95, blue: 1.0)
    static let cosmicBlue = Color(red: 0.1, green: 0.3, blue: 0.8)
    static let auroraGreen = Color(red: 0.2, green: 0.8, blue: 0.6)
    static let marsRed = Color(red: 0.8, green: 0.2, blue: 0.2)
}

extension ShapeStyle where Self == Color {
    static var cosmicBackground: Color { .init(red: 0.04, green: 0.04, blue: 0.12) }
    static var nebulaDeep: Color { .init(red: 0.3, green: 0.1, blue: 0.6) }
    static var nebulaGlow: Color { .init(red: 0.5, green: 0.2, blue: 0.9) }
    static var celestialGold: Color { .init(red: 1.0, green: 0.82, blue: 0.25) }
    static var starWhite: Color { .init(red: 0.95, green: 0.95, blue: 1.0) }
    static var cosmicBlue: Color { .init(red: 0.1, green: 0.3, blue: 0.8) }
    static var auroraGreen: Color { .init(red: 0.2, green: 0.8, blue: 0.6) }
    static var marsRed: Color { .init(red: 0.8, green: 0.2, blue: 0.2) }
}
