import SwiftUI

struct HomeView: View {
    private let messages: [String] = [
        "The cosmos align in your favour today. An unexpected connection carries the energy of transformation. Trust the pull of intuition over logic — the stars speak through feeling, not reason. Your light is visible from galaxies far away.",
        "Mercury dances with Venus at dawn, stirring the winds of communication. Words left unspoken carry more weight today than those said aloud. The moon whispers: patience is not passivity — it is trust in divine timing.",
        "The axis of your world tilts slightly today — an old door closes with a resonance you will feel in your chest. What the cosmos removes, it removes with purpose. By evening, the silence will feel less like emptiness and more like space.",
        "A thread of gold runs through the fabric of this day. The moment that seems smallest will prove most significant. Do not look for the grand gesture when the cosmos is speaking in whispers. Listen with your whole body.",
        "Saturn's long patience is rewarded today. The effort that has gone unwitnessed and the discipline that was its own reward are quietly compounding into something extraordinary. You have been building longer than you know.",
        "Three planets form an alignment that has not occurred in eleven years. The window this opens is specific to your particular longing. What you have wanted but been afraid to claim is asking today to be claimed.",
        "The Moon in her fullness illuminates what you have been carrying in darkness. Revelation is not punishment — it is the universe deciding you are ready to see. Look at what the light reveals without flinching.",
        "A cycle completes tonight that began long before you had language for what you were entering. The closing of a circle is not an ending but the drawing of a full breath. What comes next begins with this exhale.",
        "Jupiter's generosity touches every endeavour you begin today with an unusual abundance. The investment of energy right now will compound in ways that exceed ordinary calculation. Begin. The cosmos is already matching your contribution.",
        "Your sensitivity today is a form of intelligence operating below the threshold of ordinary consciousness. Trust what your body knows before your mind has processed it. The feeling is accurate. Act on it.",
        "Mars fires its energy through your chart with unusual clarity. The confrontation you have been circling, the project you have been delaying, the truth you have been softening — today is the day for directness. The window is open.",
        "The Pleiades rise before dawn and with them comes the energy of deep memory — of what you knew before you learned to doubt your knowing. Let ancient certainty surface through the noise of modern hesitation.",
        "Something sacred is completing its first full revolution in your life today. The anniversary of an inner transformation is being marked by the cosmos with gentle ceremony. Acknowledge the distance you have traveled.",
        "Neptune dissolves what was rigid between you and what you most desire. The barrier was always softer than it appeared. The thing you reached for is closer than the space between your fingers suggested.",
        "A star you cannot see is exerting a gravitational influence on everything happening in your life right now. Trust the pull. The star knows where it is taking you, even when the navigator's instruments show nothing.",
        "The universe has placed a question in the architecture of this day and hidden the answer in the last hour before sleep. Pay attention to what you are thinking when you are almost finished thinking.",
        "Venus moves through a corridor of your chart she visits only rarely, and the beauty she leaves in her wake is real: a conversation that illuminates, a connection that deepens, a piece of art that finds its form.",
        "The cardinal direction of today is inward. Everything outside is the surface; everything essential is at the centre. Spend more time today at the centre than you ordinarily allow yourself. The periphery will wait.",
        "An opportunity dressed in the clothing of an inconvenience is asking to be recognised for what it actually is. The delay, the detour, the unexpected request — one of these is a door. Look more carefully.",
        "The stars have been slow today — deliberate, patient, setting the stage for something that will require the audience's full attention. Take your seat. The performance begins precisely when it is ready.",
        "Your dreaming mind has been preparing something that your waking mind has not yet received. The images and impulses of the last several nights are not random. They are instructions written in a language older than words.",
        "Light travels from distant stars for thousands of years to arrive at this exact moment in your atmosphere. What reaches you today has been in motion for longer than you have existed. Receive it as the ancient gift it is.",
        "The energy of completion is everywhere today — in the arc of the sun, in the quality of the light, in the feeling that something large has almost finished becoming what it was always going to be. You are witnessing a conclusion.",
        "Chiron, the wounded healer, moves through a sensitive corridor today, and what it touches is precisely the wound that has been most resistant to healing. The tenderness you feel is not weakness — it is the sign of work beginning.",
        "A new frequency is becoming available to you — a way of understanding your own life from an altitude you have not previously occupied. The shift in perspective is permanent once it occurs. Today it occurs.",
        "The seventh house of unexpected alliance is activated today by a stellium of inner planets. The person who enters your life through a seemingly coincidental encounter is not coincidental. Greet them as what they are.",
        "The bridge between what you have been and what you are becoming is visible today as the space between two breaths. The inhale was the old life; the exhale is the new. You are presently between them.",
        "Your ancestral line reaches through you toward something it never reached when it was alive. The dream your grandparents could not fully dream is living inside your daily choices. What you do with your freedom matters beyond you.",
        "The cosmos have arranged today's events with the precision of a master choreographer. Nothing that happens is accidental. The stumbling is part of the dance. The pause is the dance. You are always in the dance.",
        "A retrograde planet stations direct today, and what was blocked begins to move with sudden grace. The letter arrives. The misunderstanding resolves. The project that was stalled finds its forward velocity."
    ]

    private var todayMessage: String {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return messages[dayOfYear % messages.count]
    }

    private var dateString: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMMM d"
        return f.string(from: Date())
    }

    var body: some View {
        ZStack {
            CosmicBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Date header
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text(dateString.uppercased())
                            .font(FortunaFont.caption(11))
                            .foregroundStyle(Color.textTertiary)
                            .tracking(2)

                        Text("Fortuna")
                            .font(FortunaFont.display(36))
                            .foregroundStyle(Color.textPrimary)
                    }
                    .padding(.top, 64)
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.bottom, Spacing.xl)

                    // Hero daily message card
                    FortunaCard(padding: Spacing.lg) {
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            HStack(spacing: Spacing.xs) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.accentGold)
                                Text("Today's Message")
                                    .font(FortunaFont.caption(11))
                                    .foregroundStyle(Color.accentGold)
                                    .tracking(1.5)
                                Spacer()
                            }

                            Text(todayMessage)
                                .font(FortunaFont.body(15))
                                .foregroundStyle(Color.textSecondary)
                                .lineSpacing(6)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(.horizontal, Spacing.screenHorizontal)
                    .padding(.bottom, Spacing.lg)

                    // Category cards
                    VStack(spacing: Spacing.sm) {
                        Text("Explore")
                            .font(FortunaFont.caption(11))
                            .foregroundStyle(Color.textTertiary)
                            .tracking(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, Spacing.screenHorizontal)

                        HomeFeatureCard(
                            icon: "rectangle.stack",
                            title: "Tarot",
                            subtitle: "Daily, monthly, and yearly spreads",
                            tint: Color.tarotTint
                        )
                        HomeFeatureCard(
                            icon: "moon.stars",
                            title: "Astrology",
                            subtitle: "Your natal chart and transits",
                            tint: Color.astrologyTint
                        )
                        HomeFeatureCard(
                            icon: "seal",
                            title: "사주 · Four Pillars",
                            subtitle: "Destiny encoded in your birth moment",
                            tint: Color.sajuTint
                        )
                    }
                    .padding(.bottom, 120)
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Feature Card

struct HomeFeatureCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let tint: Color

    var body: some View {
        FortunaCard(padding: Spacing.md, tint: tint) {
            HStack(spacing: Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .light))
                    .foregroundStyle(tint)
                    .frame(width: 36)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(FortunaFont.displayMedium(15))
                        .foregroundStyle(Color.textPrimary)
                    Text(subtitle)
                        .font(FortunaFont.caption(12))
                        .foregroundStyle(Color.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .light))
                    .foregroundStyle(Color.textTertiary)
            }
        }
        .padding(.horizontal, Spacing.screenHorizontal)
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
