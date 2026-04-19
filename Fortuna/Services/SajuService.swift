import Foundation

class SajuService: @unchecked Sendable {
    static let shared = SajuService()
    private init() {}

    // MARK: - Year Pillar
    // Ipchun correction: if birthday is before Ipchun (~Feb 4), use previous year.

    static func yearPillar(year: Int, month: Int, day: Int) -> SajuPillar {
        var y = year
        if month == 1 || (month == 2 && day < 4) { y -= 1 }
        let offset = y - 4
        let stemIdx  = ((offset % 10) + 10) % 10
        let branchIdx = ((offset % 12) + 12) % 12
        return SajuPillar(
            stem: HeavenlyStem(rawValue: stemIdx)!,
            branch: EarthlyBranch(rawValue: branchIdx)!
        )
    }

    // MARK: - Month Branch (solar-term based)
    // Solar terms (Jieqi): approximate day the month branch changes.
    // Branch 2 (寅) starts ~Feb 4, 3 (卯) ~Mar 6, … 1 (丑) ~Jan 6, 0 (子) ~Dec 7.

    static func monthBranchIndex(month: Int, day: Int) -> Int {
        // solTerm[m-1] = day of month when the month branch increments
        let solTerm = [6, 4, 6, 5, 6, 6, 7, 8, 8, 8, 7, 7]
        // Branch starts at 寅(2) for the Ipchun month (Feb)
        // Month branch index = (month - 2 + 12) % 12, adjusted if day < solar-term day
        let base = (month + 10) % 12   // month 1→11,2→0,3→1,…12→10, gives 寅(2) for Feb:  (2+10)%12=0? No.
        // Simpler: branch for calendar month m (if day >= solTerm) else branch for m-1
        // Mapping: branch 2=Jan→寅? No. Standard mapping:
        //   寅(2) starts Feb ~4, 卯(3) Mar ~6, 辰(4) Apr ~5, 巳(5) May ~6,
        //   午(6) Jun ~6, 未(7) Jul ~7, 申(8) Aug ~8, 酉(9) Sep ~8, 戌(10) Oct ~8,
        //   亥(11) Nov ~7, 子(0) Dec ~7, 丑(1) Jan ~6
        // So: branchForMonth[month-1] = branch when day >= solTerm
        let branchForMonth = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0]  // Jan=丑(1)…Dec=子(0)
        let prevBranch = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]       // previous branch

        let idx = month - 1
        if day >= solTerm[idx] {
            return branchForMonth[idx]
        } else {
            return prevBranch[idx]
        }
    }

    // MARK: - Month Stem

    static func monthStemIndex(yearStemIdx: Int, monthBranchIdx: Int) -> Int {
        // Base stem for month starting at 寅(branch 2) depends on year stem group
        // Year stem 甲(0)/己(5) → 寅month stem = 丙(2)
        // Year stem 乙(1)/庚(6) → 寅month stem = 戊(4)
        // Year stem 丙(2)/辛(7) → 寅month stem = 庚(6)
        // Year stem 丁(3)/壬(8) → 寅month stem = 壬(8)
        // Year stem 戊(4)/癸(9) → 寅month stem = 甲(0)
        let bases = [2, 4, 6, 8, 0, 2, 4, 6, 8, 0]
        let base = bases[yearStemIdx]
        // From 寅(2), each branch step adds 1 stem: offset = (branchIdx - 2 + 12) % 12
        let offset = (monthBranchIdx - 2 + 12) % 12
        return (base + offset) % 10
    }

    // MARK: - Day Pillar (Julian Day Number)

    static func julianDayNumber(year: Int, month: Int, day: Int) -> Int {
        let a = (14 - month) / 12
        let y = year + 4800 - a
        let m = month + 12 * a - 3
        return day + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400 - 32045
    }

    static func dayPillar(date: Date) -> SajuPillar {
        let cal = Calendar.current
        let y = cal.component(.year, from: date)
        let m = cal.component(.month, from: date)
        let d = cal.component(.day, from: date)

        let jdn = julianDayNumber(year: y, month: m, day: d)
        // Reference: JDN 2451545 = Jan 1 2000 = 庚辰 (stem 6, branch 4)
        // Offset chosen so that (jdn - 2451545 + 16) % 60 = 0 gives 甲子(0,0)
        // dayPos 0 = 甲子, so stemIdx = dayPos % 10, branchIdx = dayPos % 12
        let dayPos = ((jdn - 2451545 + 16) % 60 + 60) % 60
        let stemIdx = dayPos % 10
        let branchIdx = dayPos % 12
        return SajuPillar(
            stem: HeavenlyStem(rawValue: stemIdx)!,
            branch: EarthlyBranch(rawValue: branchIdx)!
        )
    }

    // MARK: - Hour Pillar

    static func hourBranchIndex(hour: Int) -> Int {
        if hour == 23 { return 0 }
        return (hour + 1) / 2
    }

    static func hourPillar(hour: Int, dayStemIdx: Int) -> SajuPillar {
        let branchIdx = hourBranchIndex(hour: hour)
        let base = (dayStemIdx % 5) * 2
        let stemIdx = (base + branchIdx) % 10
        return SajuPillar(
            stem: HeavenlyStem(rawValue: stemIdx)!,
            branch: EarthlyBranch(rawValue: branchIdx)!
        )
    }

    // MARK: - Full Chart

    static func chart(birthDate: Date, birthHour: Int) -> SajuChart {
        let cal = Calendar.current
        let year  = cal.component(.year, from: birthDate)
        let month = cal.component(.month, from: birthDate)
        let day   = cal.component(.day, from: birthDate)

        let yp = yearPillar(year: year, month: month, day: day)
        let monthBranch = monthBranchIndex(month: month, day: day)
        let monthStem   = monthStemIndex(yearStemIdx: yp.stem.rawValue, monthBranchIdx: monthBranch)
        let mp = SajuPillar(stem: HeavenlyStem(rawValue: monthStem)!,
                            branch: EarthlyBranch(rawValue: monthBranch)!)
        let dp = dayPillar(date: birthDate)
        let hp = hourPillar(hour: birthHour, dayStemIdx: dp.stem.rawValue)

        return SajuChart(
            yearPillar: yp, monthPillar: mp, dayPillar: dp, hourPillar: hp,
            birthDate: birthDate, birthHour: birthHour
        )
    }

    // MARK: - Fortune Text

    static func fortuneText(for chart: SajuChart, period: FortunePeriod) -> String {
        let element = chart.dominantElement
        let fortunes = SajuFortunes.fortunes(for: element, period: period)
        let seed: Int
        switch period {
        case .daily:
            seed = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        case .monthly:
            let c = Calendar.current.dateComponents([.month, .year], from: Date())
            seed = (c.year ?? 2024) * 100 + (c.month ?? 1)
        case .yearly:
            seed = Calendar.current.component(.year, from: Date())
        }
        return fortunes[seed % fortunes.count]
    }
}

// MARK: - Saju Fortune Text

enum SajuFortunes {
    static func fortunes(for element: FiveElement, period: FortunePeriod) -> [String] {
        switch period {
        case .daily:   return dailyFortunes(for: element)
        case .monthly: return monthlyFortunes(for: element)
        case .yearly:  return yearlyFortunes(for: element)
        }
    }

    private static func dailyFortunes(for element: FiveElement) -> [String] {
        switch element {
        case .wood:
            return [
                "목(木)의 기운이 오늘 당신의 주변을 감쌉니다. The energy of Wood — the vital force of spring, of upward growth, of reaching toward light — moves through your chart today with particular clarity. Something you have been nurturing in secret is ready to break through the soil. Do not restrain the emergence.",
                "Wood energy governs vision and new beginnings. Today, a project or idea that has been developing underground — invisible to others and perhaps even to yourself — pushes through the surface with the unstoppable insistence of a seedling. This is not the time for pruning. It is the time for letting grow.",
                "The Wood element that dominates your chart speaks of the liver meridian, of the capacity to plan and execute, and of the deep anger that arises when growth is blocked. Today, something that has been blocking your natural expansion is removed. Notice the relief in your body before the mind has catalogued what changed.",
                "Spring wood bends in wind but does not break. This flexibility-within-rootedness is your inheritance today. A challenge that would snap something more rigid will bend you, briefly, before your natural resilience straightens the arc. You will return to your upward direction.",
                "The colour of wood is green — the colour of healing, of new life, of the world after rain. Today, allow yourself to be genuinely nourished by something alive. A walk among trees, the touch of a plant, a meal made from freshly grown things — the element recognises itself in its expressions."
            ]
        case .fire:
            return [
                "화(火)의 기운이 활활 타오릅니다. The Fire element blazes through your chart today, igniting your charisma, your perception, and your capacity to be seen. What you bring into a room today is warmth that other people will feel in their bodies before they have named it. You are a living fire.",
                "Fire governs the heart, the small intestine, and the quality of joy that arises not from circumstances but from the inner flame maintaining its temperature. Today, that flame is high and steady. The clarity of a warm fire — its ability to illuminate without blinding — is your gift in every conversation.",
                "The ancient texts say that Fire's gift is propriety — the knowing of what is appropriate in each moment. Your social intelligence today operates with unusual precision. You will say the right thing, at the right time, to the right person. This is Fire's highest expression.",
                "Passion is both Fire's gift and its danger. The flame that warms can also consume. Today, the passion is right-sized and rightly directed. Something you care about deeply receives the intensity of your focused attention, and the result is that it shines.",
                "화기(火氣) — the quality of fire energy — moves through the meridians of your heart today with particular warmth. A joy you had forgotten was available to you surfaces unexpectedly in a small moment: the sound of someone you love, a light through glass, a memory arriving as a gift."
            ]
        case .earth:
            return [
                "토(土)의 기운이 땅처럼 단단합니다. Earth energy is the ground beneath all other elements — the stable centre, the fertile soil, the midpoint of the cycle. Today you are the ground upon which others stand, the stable presence in a situation that needs exactly your particular quality of unshakeable reliability.",
                "The Earth element governs the stomach and spleen — the organs of reception and transformation, of taking in the world and extracting nourishment from it. Today, you have an unusual capacity to find the sustaining quality in whatever you encounter. Even the difficult thing has something of value in it for you.",
                "토기(土氣) — the energy of the earth element — is about integration and synthesis. Where other elements move in one direction, Earth sits at the centre and holds the relationship between all of them. Your gift today is the mediation, the finding of the common ground, the seeing of what connects what appears to oppose.",
                "The Earth element at its highest expression becomes the great mother — the inexhaustible provider who gives without diminishment because what she gives comes from the same principle that replenishes the soil after each harvest. Today, your generosity flows from this inexhaustible place.",
                "Solidity, reliability, and the long-term perspective — these are Earth's gifts today. In a world of constant motion and flux, your steadiness is not passivity but presence. You are the thing that does not move when everything else does, and that stillness is the most useful thing in the room."
            ]
        case .metal:
            return [
                "금(金)의 기운이 예리하게 빛납니다. Metal energy brings precision, clarity, and the capacity for discernment today. The lung meridian that Metal governs speaks of the first breath — of the boundary between the self and the world, of the inhale that begins all action and the exhale that releases what is finished.",
                "Metal governs the quality of preciousness — the ability to recognise what is genuinely valuable and to release what only appeared to be. Today, a discernment is available to you about something in your life that has been carrying more weight than it merits. The letting go is an act of Metal's refinement.",
                "금기(金氣) speaks of autumn — the season of harvest, of clear skies, of the world becoming both beautiful and austere simultaneously. Today has this quality: a poignant clarity that sees things as they are, neither adding nor subtracting from their actual nature. What you see clearly today, you see truly.",
                "The ancient smiths understood that metal must be heated, beaten, and cooled many times before it reaches its final form. What you have been through has been this process. Today, you feel the precision of the finished instrument — the edge that was earned through the full cycle of refinement.",
                "Metal energy calls for ceremony — for the marking of endings and beginnings with explicit acknowledgment. Today, something that has completed its natural arc deserves a conscious closing: a word said, a gesture made, a moment of deliberate recognition that this chapter is done."
            ]
        case .water:
            return [
                "수(水)의 기운이 깊은 곳에서 흐릅니다. Water energy moves through your chart today from the depths — from the kidney meridian that governs the fundamental life force, the will to exist, the root of all vitality. Today you have access to something ancient and pre-personal: the reservoir from which all initiative ultimately draws.",
                "Water at its highest expression is wisdom — not the cleverness of the quick mind but the deep knowing of the one who has been still long enough to see the bottom. Today, that depth of seeing is available. What appears on the surface is not the whole truth of the situation.",
                "수기(水氣) — water energy — is the energy of winter, of potential before expression, of the seed before the spring. There is something in you today that is not yet ready to show itself, and this is entirely appropriate. Not everything needs to be known about yet. Some growings require darkness.",
                "The kidney energy in Korean medicine is the root of courage — not the hot courage of fire but the cold courage of the one who acts from deep necessity rather than emotion. Today, you have access to this quiet, inexhaustible form of courage. It will not announce itself. It will simply be present when required.",
                "Water finds every crack and permeates where force cannot. Your intelligence today operates with this quality: not the direct assault but the finding of the opening, the filling of the space that was left. The flexible approach reaches places that the rigid one cannot."
            ]
        }
    }

    private static func monthlyFortunes(for element: FiveElement) -> [String] {
        switch element {
        case .wood:
            return [
                "This month, Wood energy reaches a seasonal peak that amplifies your natural capacity for vision and growth. A plan that has been forming in the background of your consciousness is ready to move into deliberate execution. The roots are established; the upward movement can now begin in earnest.",
                "The Wood element's relationship with spring makes this month one of genuine renewal. Something you had written off as finished turns out to have been merely dormant. The new growth emerging from what appeared dead is the month's central image.",
                "목기운(木氣運) fills this month with the energy of expansion and possibility. A professional or creative endeavour enters its most fertile phase. What you plant now with real intention will be harvestable in ways that exceed your expectations."
            ]
        case .fire:
            return [
                "Fire energy reaches a peak of expression this month that makes you unusually magnetic. The warmth and clarity you radiate are being received by people who matter in your field and in your relationships. This is a month to be seen, to express, and to allow the natural heat of your presence to do its persuasive work.",
                "The heart's energy governs this month's primary theme: the question of where your truest joy resides and whether your current life is structured to allow that joy its full expression. An adjustment becomes possible this month that aligns your outer circumstances more closely with your inner flame.",
                "화기운(火氣運) illuminates this month with an intensity of perception and connection. A relationship that has been operating at the surface level drops suddenly into genuine depth. The warmth is mutual. The recognition is real."
            ]
        case .earth:
            return [
                "Earth energy grounds this month in the most productive possible way. The foundations you have been building — in work, in relationship, in your material circumstances — are showing their solidity in concrete and verifiable ways. Something built carefully over time is proving its durability.",
                "The Earth element's gift of nurturing reaches outward this month to include not just those in your immediate circle but something larger. A contribution you make to a community or cause has an impact that exceeds its apparent scale. The Earth feeds everything that grows in it.",
                "토기운(土氣運) fills this month with a quality of stable fertility. What you invest your steadiness and consistency in this month will grow reliably and well. The harvest of reliable investment is this month's primary gift."
            ]
        case .metal:
            return [
                "Metal energy brings this month to a precise point of clarity about something that has been unclear. A decision made with Metal's discernment — from the principle of what is genuinely valuable rather than what is merely appealing — will prove to be one of the most important of the year.",
                "The refinement impulse of Metal energy makes this an excellent month for editing, pruning, and releasing what no longer serves. Something in your life — a habit, a relationship dynamic, a professional approach — is ready for the Metal element's clarifying process.",
                "금기운(金氣運) fills this month with the quality of autumn clarity. What is real is visible with unusual precision. A truth you have been approaching obliquely can now be seen directly, and the seeing, though momentarily uncomfortable, is profoundly liberating."
            ]
        case .water:
            return [
                "Water energy makes this month unusually receptive — to insight, to deep connection, and to the kind of wisdom that arrives in stillness rather than activity. Carve out time for genuine quiet this month. What emerges from the depths of that silence will be more valuable than everything produced in the noise.",
                "The depth that Water governs is particularly accessible this month. Something beneath the surface of your life — a recurring pattern, an old wound, a persistent dream — is ready to be seen completely. The seeing is the beginning of the transformation.",
                "수기운(水氣運) fills this month with the quality of deep winter: a sacred stillness from which all subsequent activity will be nourished. The month that appears least productive is often the one that makes everything after it possible."
            ]
        }
    }

    private static func yearlyFortunes(for element: FiveElement) -> [String] {
        switch element {
        case .wood:
            return [
                "This is a year of extraordinary growth for those with dominant Wood energy. The long preparation is complete, and the upward movement that has been delayed by conditions not entirely within your control is finally unobstructed. What grows this year grows quickly and strongly, reaching heights that earlier assessments had not anticipated.",
                "Wood's long view comes into its clearest expression this year. The decade-scale vision you have been holding — the one that seemed almost too ambitious to speak aloud — aligns this year with practical possibility in ways that prove the vision was not fantasy but foresight."
            ]
        case .fire:
            return [
                "A year of radiant expression and the recognition that follows it. The Fire element that shapes your chart blazes with particular brightness this year, and what you bring into the world — creatively, professionally, personally — carries the signature of something genuinely lit from within. This is a year to be seen.",
                "Fire's cycle of peak and renewal is completing this year. If the flame has felt lower recently, the year brings a resurgence from a source deeper than the one that was depleted. The new fire burns more cleanly and more sustainably than anything before it."
            ]
        case .earth:
            return [
                "A year of consolidation and the deep satisfaction of what has been built. Earth energy reaches a kind of maturity this year that allows you to rest — briefly, meaningfully — in the knowledge that the structures you have been building are sound. From this foundation, the next chapter begins.",
                "The Earth element's patience is rewarded this year in material, relational, and spiritual terms simultaneously. What has been tended consistently and without fanfare reveals its accumulated value. The harvest is substantial."
            ]
        case .metal:
            return [
                "A year of significant refinement and the clarity it produces. Metal energy sharpens your entire life to its most essential expression this year, removing what is not genuine and leaving what is irreducibly yours. The process is sometimes uncomfortable; the result is extraordinary.",
                "The Metal element's connection to legacy comes into focus this year. What you leave behind — in the world, in relationships, in the body of work you are building — receives deliberate attention. The question of what is truly worth doing is answered more clearly than ever before."
            ]
        case .water:
            return [
                "A year of profound depth and the wisdom it produces. Water energy carries your consciousness into territory that surface-level awareness cannot access, and what you discover in those depths reorganises your understanding of your own life. This is a year of inner transformation that the outer world will only begin to reflect in the years following.",
                "Water's inexhaustible nature becomes visible this year as you discover that the resource you feared was finite is actually being continuously renewed. The courage you draw from the deepest place in yourself is replenished each time it is used. You will not run out."
            ]
        }
    }
}
