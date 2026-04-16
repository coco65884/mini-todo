import SwiftUI

enum AppTab: String, CaseIterable {
    case todo = "Todo"
    case memo = "Memo"

    private static let userDefaultsKey = "lastSelectedTab"

    static func loadLast() -> AppTab {
        guard let raw = UserDefaults.standard.string(forKey: userDefaultsKey),
              let tab = AppTab(rawValue: raw)
        else {
            return .todo
        }
        return tab
    }

    func saveLast() {
        UserDefaults.standard.set(rawValue, forKey: Self.userDefaultsKey)
    }
}

struct MainTabView: View {
    @ObservedObject var todoStore: TodoStore
    @ObservedObject var memoStore: MemoStore
    @State private var selectedTab: AppTab = AppTab.loadLast()

    var body: some View {
        VStack(spacing: 0) {
            tabBar
            Divider()
            tabContent
        }
        .frame(width: 320, height: 400)
        .onKeyPress(.tab, phases: .down) { _ in
            switchTab()
            return .handled
        }
        .onChange(of: selectedTab) { _, newTab in
            newTab.saveLast()
        }
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    Text(tab.rawValue)
                        .font(.subheadline)
                        .fontWeight(selectedTab == tab ? .semibold : .regular)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            selectedTab == tab
                                ? Color.accentColor.opacity(0.1)
                                : Color.clear
                        )
                        .foregroundStyle(
                            selectedTab == tab ? .primary : .secondary
                        )
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .frame(height: 32)
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .todo:
            ContentView(store: todoStore)
        case .memo:
            MemoView(store: memoStore)
        }
    }

    private func switchTab() {
        let allTabs = AppTab.allCases
        guard let index = allTabs.firstIndex(of: selectedTab) else { return }
        let nextIndex = (index + 1) % allTabs.count
        selectedTab = allTabs[nextIndex]
    }
}
