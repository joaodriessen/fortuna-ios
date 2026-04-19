import SwiftUI

// MARK: - Color Palette

extension Color {
    // Backgrounds
    static let appBackground   = Color(hex: "0C0C1E")   // deep midnight navy
    static let surfaceBase     = Color(hex: "14142A")   // card/elevated surface
    static let surfaceRaised   = Color(hex: "1C1C38")   // modal/sheet surface

    // Text
    static let textPrimary     = Color(hex: "EDE8DF")   // warm ivory
    static let textSecondary   = Color(hex: "8A879E")   // muted lavender-grey
    static let textTertiary    = Color(hex: "524F68")   // very muted labels/metadata

    // Accents
    static let accentGold      = Color(hex: "C8A97A")   // antique warm gold
    static let accentPurple    = Color(hex: "7C6FCD")   // soft medium purple
    static let accentBlue      = Color(hex: "4A7FA5")   // steel blue

    // Category colours (muted, not bright)
    static let tarotTint       = Color(hex: "9A6B8A")   // dusty mauve
    static let astrologyTint   = Color(hex: "4A7FA5")   // steel blue
    static let sajuTint        = Color(hex: "5A8A70")   // sage green

    // Functional
    static let divider         = Color(hex: "FFFFFF").opacity(0.07)
    static let cardBorder      = Color(hex: "FFFFFF").opacity(0.05)
}

// MARK: - Hex Initialiser

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

// MARK: - Typography System

enum FortunaFont {
    static func display(_ size: CGFloat) -> Font {
        .system(size: size, weight: .light, design: .default)
    }
    static func displayMedium(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }
    static func body(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
    static func caption(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
}

// MARK: - Spacing Constants

enum Spacing {
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let screenHorizontal: CGFloat = 24
}
