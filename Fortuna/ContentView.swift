import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Today", systemImage: "sparkles")
                }
                .tag(0)

            TarotView()
                .tabItem {
                    Label("Tarot", systemImage: "rectangle.stack.fill")
                }
                .tag(1)

            AstrologyView()
                .tabItem {
                    Label("Astrology", systemImage: "moon.stars.fill")
                }
                .tag(2)

            SajuView()
                .tabItem {
                    Label("Saju", systemImage: "yin.yang")
                }
                .tag(3)
        }
        .tint(.celestialGold)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
