import SwiftUI

// MARK: - Cosmic Background

struct CosmicBackground: View {
    var body: some View {
        ZStack {
            // Slightly richer base for glass to float on
            Color(hex: "080818").ignoresSafeArea()

            GeometryReader { geo in
                ZStack {
                    // Purple bloom — top left
                    Circle()
                        .fill(Color(hex: "3D1B6E").opacity(0.35))
                        .frame(width: geo.size.width)
                        .blur(radius: 100)
                        .offset(x: -geo.size.width * 0.35, y: -geo.size.height * 0.15)

                    // Blue bloom — bottom right
                    Circle()
                        .fill(Color(hex: "0F3060").opacity(0.30))
                        .frame(width: geo.size.width * 0.85)
                        .blur(radius: 90)
                        .offset(x: geo.size.width * 0.3, y: geo.size.height * 0.35)

                    // Gold hint — very subtle, mid screen
                    Circle()
                        .fill(Color(hex: "4A3010").opacity(0.15))
                        .frame(width: geo.size.width * 0.5)
                        .blur(radius: 80)
                        .offset(x: geo.size.width * 0.05, y: geo.size.height * 0.1)
                }
            }
            .ignoresSafeArea()

            MinimalStarfield()
        }
    }
}

// MARK: - Minimal Starfield

struct MinimalStarfield: View {
    struct Star {
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let period: Double
        let phase: Double
    }

    let stars: [Star] = {
        var rng = SeededRNG(seed: 42)
        return (0..<90).map { _ in
            Star(
                x: CGFloat(rng.next01()),
                y: CGFloat(rng.next01()),
                size: CGFloat(rng.next01()) * 1.2 + 0.4,
                period: Double(rng.next01()) * 5 + 3,
                phase: Double(rng.next01()) * .pi * 2
            )
        }
    }()

    var body: some View {
        TimelineView(.animation) { ctx in
            Canvas { cx, size in
                let t = ctx.date.timeIntervalSinceReferenceDate
                for star in stars {
                    let twinkle = (sin(t / star.period + star.phase) + 1) / 2
                    let opacity = 0.15 + twinkle * 0.35
                    cx.opacity = opacity
                    let rect = CGRect(
                        x: star.x * size.width - star.size / 2,
                        y: star.y * size.height - star.size / 2,
                        width: star.size, height: star.size
                    )
                    cx.fill(Circle().path(in: rect), with: .color(.white))
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

// MARK: - Seeded RNG

struct SeededRNG {
    private var state: UInt64
    init(seed: UInt64) { state = seed }
    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
    mutating func next01() -> Double {
        return Double(next() >> 11) / Double(1 << 53)
    }
}

#Preview {
    CosmicBackground()
}
