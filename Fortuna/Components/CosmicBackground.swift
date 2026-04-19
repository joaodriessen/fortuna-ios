import SwiftUI

// MARK: - Cosmic Background

struct CosmicBackground: View {
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            // Extremely subtle gradient blooms
            GeometryReader { geo in
                ZStack {
                    Circle()
                        .fill(Color.accentPurple.opacity(0.10))
                        .frame(width: geo.size.width * 0.8)
                        .blur(radius: 120)
                        .offset(x: -geo.size.width * 0.2, y: -geo.size.height * 0.1)

                    Circle()
                        .fill(Color.accentBlue.opacity(0.08))
                        .frame(width: geo.size.width * 0.7)
                        .blur(radius: 100)
                        .offset(x: geo.size.width * 0.3, y: geo.size.height * 0.4)
                }
            }
            .ignoresSafeArea()

            // Sparse, quiet starfield
            MinimalStarfield()
        }
    }
}

// MARK: - Minimal Starfield

private struct StarData {
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let phaseOffset: Double
    let period: Double
}

struct MinimalStarfield: View {
    // Use a fixed seed so positions are deterministic
    private let stars: [StarData] = {
        var rng = SeededStarRNG(seed: 42)
        return (0..<80).map { _ in
            let large = rng.nextFloat() > 0.80
            return StarData(
                x: rng.nextFloat(),
                y: rng.nextFloat(),
                size: large ? rng.nextFloatIn(min: 1.0, max: 1.5) : rng.nextFloatIn(min: 0.5, max: 1.0),
                phaseOffset: Double(rng.nextFloat()) * .pi * 2,
                period: Double(rng.nextFloatIn(min: 3.0, max: 8.0))
            )
        }
    }()

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                for star in stars {
                    let opacity = (sin(time / star.period * .pi * 2 + star.phaseOffset) + 1) / 2
                    let baseOpacity = 0.2 + opacity * 0.3
                    let x = star.x * size.width
                    let y = star.y * size.height
                    let rect = CGRect(
                        x: x - star.size / 2,
                        y: y - star.size / 2,
                        width: star.size,
                        height: star.size
                    )
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(Color.textPrimary.opacity(baseOpacity))
                    )
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

// MARK: - Seeded RNG for star positions

private struct SeededStarRNG {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed &* 6364136223846793005 &+ 1442695040888963407
        if state == 0 { state = 1 }
    }

    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }

    mutating func nextFloat() -> CGFloat {
        CGFloat(next() >> 11) / CGFloat(1 << 53)
    }

    mutating func nextFloatIn(min: CGFloat, max: CGFloat) -> CGFloat {
        min + nextFloat() * (max - min)
    }
}

#Preview {
    CosmicBackground()
}
