import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Today", systemImage: "sparkle") {
                HomeView()
            }
            Tab("Tarot", systemImage: "rectangle.on.rectangle.angled") {
                TarotView()
            }
            Tab("Stars", systemImage: "moon.stars") {
                AstrologyView()
            }
            Tab("Saju", systemImage: "square.grid.2x2") {
                SajuView()
            }
        }
        .tint(Color.accentGold)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
