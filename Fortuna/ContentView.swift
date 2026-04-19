import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                TarotView()
                    .tag(1)
                AstrologyView()
                    .tag(2)
                SajuView()
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.25), value: selectedTab)

            FortunaTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Custom Tab Bar

struct FortunaTabBar: View {
    @Binding var selectedTab: Int

    private let tabs: [(icon: String, label: String)] = [
        ("sparkles",            "Today"),
        ("rectangle.stack",     "Tarot"),
        ("moon.stars",          "Stars"),
        ("seal",                "사주")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs.indices, id: \.self) { i in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = i
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tabs[i].icon)
                            .font(.system(size: 22, weight: selectedTab == i ? .medium : .light))
                            .foregroundStyle(selectedTab == i ? Color.accentGold : Color.textTertiary)
                            .scaleEffect(selectedTab == i ? 1.05 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)

                        Text(tabs[i].label)
                            .font(FortunaFont.caption(10))
                            .foregroundStyle(selectedTab == i ? Color.accentGold : Color.textTertiary)
                            .tracking(0.5)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Spacing.lg)
        .padding(.bottom, 8)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(Color.white.opacity(0.06))
                        .frame(height: 0.5)
                }
        }
    }
}

#Preview {
    ContentView()
}
