# Fortuna

A cosmic fortune-telling iOS app built with SwiftUI. Three ancient traditions, one celestial interface.

## Features

### Today
A daily cosmic greeting that changes each calendar day — seeded by date for consistency. 30+ unique, poetic messages drawn from astrological and cosmic themes.

### Tarot
- **Daily Draw**: One card drawn fresh each day. Tap to flip with a 3D card animation. Full 78-card deck with detailed upright and reversed meanings.
- **Monthly Spread**: Three-card spread (Past / Present / Future) seeded by month.
- **Yearly Spread**: Five-card Celtic Cross layout seeded by year.

### Astrology
- Birth date input to determine your zodiac sign.
- Animated zodiac wheel with your sign highlighted.
- Daily, monthly, and yearly fortune readings — 10+ unique fortunes per sign, seeded by date.
- All 12 signs with traits, ruling planets, and element information.

### Saju (사주팔자)
Korean Four Pillars of Destiny based on traditional Chinese metaphysics. Enter your birth date and hour to calculate:
- Year Pillar (년주) — social persona and early life
- Month Pillar (월주) — career and middle years
- Day Pillar (일주) — inner self and relationships
- Hour Pillar (시주) — hidden self and later years
- Five Elements analysis (Wood / Fire / Earth / Metal / Water)
- Fortune readings based on your dominant element

## Visual Design

- Deep space dark theme with animated nebula backgrounds
- Glassmorphism cards with gradient borders
- Animated starfield with shooting stars
- Three floating planets: Jupiter, Moon, Neptune
- Celestial gold accent color throughout

## Tech Stack

- **SwiftUI** — declarative UI with smooth animations
- **MVVM** architecture
- **XcodeGen** — project file generation
- **iOS 17.0+**
- **Swift 5.9+**
- No external dependencies

## Building

1. Install XcodeGen: `brew install xcodegen`
2. Generate the project: `cd ~/Projects/Fortuna && xcodegen generate`
3. Open `Fortuna.xcodeproj` in Xcode
4. Select a simulator and hit Run

## Running Tests

```bash
xcodebuild test -project Fortuna.xcodeproj -scheme Fortuna -destination 'platform=iOS Simulator,name=iPhone 16'
```

---

*"The stars have been studying you since the moment you arrived."*
