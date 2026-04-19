import Foundation

// MARK: - Five Elements & Polarity

enum FiveElement: String, CaseIterable {
    case wood = "木"
    case fire = "火"
    case earth = "土"
    case metal = "金"
    case water = "水"

    var koreanName: String {
        switch self { case .wood: return "목"; case .fire: return "화"; case .earth: return "토"; case .metal: return "금"; case .water: return "수" }
    }

    var englishName: String {
        switch self { case .wood: return "Wood"; case .fire: return "Fire"; case .earth: return "Earth"; case .metal: return "Metal"; case .water: return "Water" }
    }

    // No emoji — use Korean/Chinese names in UI
    var symbolName: String {
        switch self { case .wood: return "leaf.fill"; case .fire: return "flame.fill"; case .earth: return "mountain.2.fill"; case .metal: return "bolt.fill"; case .water: return "drop.fill" }
    }
}

enum Polarity: String {
    case yang = "陽"
    case yin = "陰"

    var korean: String { self == .yang ? "양" : "음" }
    var english: String { self == .yang ? "Yang" : "Yin" }
}

// MARK: - Heavenly Stems (10)

enum HeavenlyStem: Int, CaseIterable {
    case gab = 0    // 甲 Yang Wood
    case eul        // 乙 Yin Wood
    case byeong     // 丙 Yang Fire
    case jeong      // 丁 Yin Fire
    case mu         // 戊 Yang Earth
    case gi         // 己 Yin Earth
    case gyeong     // 庚 Yang Metal
    case sin        // 辛 Yin Metal
    case im         // 壬 Yang Water
    case gye        // 癸 Yin Water

    var koreanName: String { ["갑", "을", "병", "정", "무", "기", "경", "신", "임", "계"][rawValue] }
    var chineseName: String { ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"][rawValue] }
    var romanization: String { ["Gab", "Eul", "Byeong", "Jeong", "Mu", "Gi", "Gyeong", "Sin", "Im", "Gye"][rawValue] }
    var element: FiveElement { [.wood, .wood, .fire, .fire, .earth, .earth, .metal, .metal, .water, .water][rawValue] }
    var polarity: Polarity { rawValue % 2 == 0 ? .yang : .yin }
}

// MARK: - Earthly Branches (12)

enum EarthlyBranch: Int, CaseIterable {
    case ja = 0     // 子 Rat
    case chuk       // 丑 Ox
    case in_        // 寅 Tiger
    case myo        // 卯 Rabbit
    case jin        // 辰 Dragon
    case sa         // 巳 Snake
    case o          // 午 Horse
    case mi         // 未 Goat
    case sin        // 申 Monkey
    case yu         // 酉 Rooster
    case sul        // 戌 Dog
    case hae        // 亥 Pig

    var koreanName: String { ["자", "축", "인", "묘", "진", "사", "오", "미", "신", "유", "술", "해"][rawValue] }
    var chineseName: String { ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"][rawValue] }
    var animal: String { ["Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake", "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig"][rawValue] }
    var animalKorean: String { ["쥐", "소", "호랑이", "토끼", "용", "뱀", "말", "양", "원숭이", "닭", "개", "돼지"][rawValue] }

    // Branch element mapping:
    // 子(0)=Water, 丑(1)=Earth, 寅(2)=Wood, 卯(3)=Wood, 辰(4)=Earth, 巳(5)=Fire
    // 午(6)=Fire,  未(7)=Earth, 申(8)=Metal, 酉(9)=Metal, 戌(10)=Earth, 亥(11)=Water
    var element: FiveElement {
        [.water, .earth, .wood, .wood, .earth, .fire, .fire, .earth, .metal, .metal, .earth, .water][rawValue]
    }
}

// MARK: - Saju Pillar

struct SajuPillar {
    let stem: HeavenlyStem
    let branch: EarthlyBranch

    var chineseDisplay: String { stem.chineseName + branch.chineseName }
    var koreanDisplay: String { stem.koreanName + branch.koreanName }
    var romanization: String { stem.romanization + "-" + branch.animal }
}

// MARK: - Saju Chart

struct SajuChart {
    let yearPillar: SajuPillar
    let monthPillar: SajuPillar
    let dayPillar: SajuPillar
    let hourPillar: SajuPillar
    let birthDate: Date
    let birthHour: Int

    var allPillars: [SajuPillar] { [yearPillar, monthPillar, dayPillar, hourPillar] }

    // Count elements from all 8 characters (4 stems + 4 branches)
    var elementCounts: [FiveElement: Int] {
        var counts: [FiveElement: Int] = [.wood: 0, .fire: 0, .earth: 0, .metal: 0, .water: 0]
        for pillar in allPillars {
            counts[pillar.stem.element, default: 0] += 1
            counts[pillar.branch.element, default: 0] += 1
        }
        return counts
    }

    var dominantElement: FiveElement {
        var counts: [FiveElement: Int] = [.wood: 0, .fire: 0, .earth: 0, .metal: 0, .water: 0]
        for pillar in allPillars {
            counts[pillar.stem.element, default: 0] += 1
            counts[pillar.branch.element, default: 0] += 1
        }
        return counts.max(by: { $0.value < $1.value })?.key ?? .water
    }

    var elementPercentages: [FiveElement: Double] {
        let total = Double(elementCounts.values.reduce(0, +))
        guard total > 0 else { return [:] }
        return elementCounts.mapValues { Double($0) / total }
    }
}

// MARK: - Fortune Period

enum FortunePeriod {
    case daily, monthly, yearly
}
