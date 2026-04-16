import SwiftUI

enum AppTab: String, CaseIterable {
    case todo = "Todo"
    case memo = "Memo"
}

struct MainTabView: View {
    @ObservedObject var todoStore: TodoStore
    @ObservedObject var memoStore: MemoStore
    @State private var selectedTab: AppTab = .todo

    var body: some View {
        VStack(spacing: 0) {
            tabBar
            Divider()
            tabContent
        }
        .frame(width: 320, height: 400)
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
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(
                            selectedTab == tab
                                ? Color.accentColor.opacity(0.1)
                                : Color.clear
                        )
                        .foregroundStyle(
                            selectedTab == tab ? .primary : .secondary
                        )
                }
                .buttonStyle(.plain)
            }
        }
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
}
