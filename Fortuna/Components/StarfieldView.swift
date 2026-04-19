import SwiftUI

private struct Star {
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let phaseOffset: Double
    let speed: Double
}

struct StarfieldView: View {
    private let smallStars: [Star] = (0..<150).map { _ in
        Star(
            x: CGFloat.random(in: 0...1),
            y: CGFloat.random(in: 0...1),
            size: CGFloat.random(in: 0.5...1.5),
            phaseOffset: Double.random(in: 0...(.pi * 2)),
            speed: Double.random(in: 1.5...4.0)
        )
    }

    private let largeStars: [Star] = (0..<20).map { _ in
        Star(
            x: CGFloat.random(in: 0...1),
            y: CGFloat.random(in: 0...1),
            size: CGFloat.random(in: 1.5...2.5),
            phaseOffset: Double.random(in: 0...(.pi * 2)),
            speed: Double.random(in: 1.0...2.5)
        )
    }

    @State private var shootingStarActive = false
    @State private var shootingProgress: CGFloat = 0
    @State private var shootingStartX: CGFloat = 0
    @State private var shootingStartY: CGFloat = 0

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate

                // Draw small stars
                for star in smallStars {
                    let opacity = (sin(time * star.speed + star.phaseOffset) + 1) / 2 * 0.7 + 0.1
                    let x = star.x * size.width
                    let y = star.y * size.height
                    let rect = CGRect(x: x - star.size / 2, y: y - star.size / 2,
                                      width: star.size, height: star.size)
                    context.fill(Path(ellipseIn: rect),
                                 with: .color(.starWhite.opacity(opacity)))
                }

                // Draw large stars with stronger twinkle
                for star in largeStars {
                    let opacity = (sin(time * star.speed + star.phaseOffset) + 1) / 2 * 0.9 + 0.1
                    let x = star.x * size.width
                    let y = star.y * size.height
                    // Glow
                    let glowRect = CGRect(x: x - star.size * 1.5, y: y - star.size * 1.5,
                                         width: star.size * 3, height: star.size * 3)
                    context.fill(Path(ellipseIn: glowRect),
                                 with: .color(.celestialGold.opacity(opacity * 0.2)))
                    let rect = CGRect(x: x - star.size / 2, y: y - star.size / 2,
                                      width: star.size, height: star.size)
                    context.fill(Path(ellipseIn: rect),
                                 with: .color(.celestialGold.opacity(opacity)))
                }

                // Shooting star
                if shootingStarActive {
                    let startX = shootingStartX * size.width
                    let startY = shootingStartY * size.height
                    let endX = startX + size.width * 0.25 * shootingProgress
                    let endY = startY + size.height * 0.1 * shootingProgress

                    var streakPath = Path()
                    streakPath.move(to: CGPoint(x: startX, y: startY))
                    streakPath.addLine(to: CGPoint(x: endX, y: endY))

                    context.stroke(streakPath,
                                   with: .color(.white.opacity(Double(1 - shootingProgress) * 0.9)),
                                   lineWidth: 1.5)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            triggerShootingStar()
        }
    }

    private func triggerShootingStar() {
        let delay = Double.random(in: 5...8)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            shootingStartX = CGFloat.random(in: 0...0.6)
            shootingStartY = CGFloat.random(in: 0...0.4)
            shootingProgress = 0
            shootingStarActive = true
            withAnimation(.linear(duration: 0.8)) {
                shootingProgress = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                shootingStarActive = false
                triggerShootingStar()
            }
        }
    }
}

#Preview {
    ZStack {
        Color.cosmicBackground.ignoresSafeArea()
        StarfieldView()
    }
}
