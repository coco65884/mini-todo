import AppKit
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
    var onOpenSettings: () -> Void
    @State private var selectedTab: AppTab = AppTab.loadLast()
    @State private var tabMonitor: Any?
    @State private var focusTrigger = UUID()
    @State private var showLoginHint = !UserDefaults.standard.bool(forKey: "didShowLoginHint")

    var body: some View {
        VStack(spacing: 0) {
            tabBar
            Divider()
            if showLoginHint {
                loginHintBanner
                Divider()
            }
            tabContent
        }
        .frame(width: 320, height: 400)
        .onAppear { installTabMonitor() }
        .onDisappear { removeTabMonitor() }
        .onChange(of: selectedTab) { _, newTab in
            newTab.saveLast()
            focusTrigger = UUID()
        }
    }

    private var tabBar: some View {
        ZStack(alignment: .trailing) {
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
            .padding(.trailing, 32)

            Button {
                onOpenSettings()
            } label: {
                Image(systemName: "gearshape")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .help("設定")
        }
        .frame(height: 32)
    }

    private var loginHintBanner: some View {
        HStack(spacing: 6) {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(.blue)
                .font(.caption)
            Text("ログイン時に自動起動すると便利です")
                .font(.caption2)
            Spacer()
            Button("設定を開く") {
                openLoginItemSettings()
                dismissLoginHint()
            }
            .font(.caption2)
            .buttonStyle(.bordered)
            .controlSize(.mini)
            Button {
                dismissLoginHint()
            } label: {
                Image(systemName: "xmark")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.blue.opacity(0.08))
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .todo:
            ContentView(store: todoStore, focusTrigger: focusTrigger)
        case .memo:
            MemoView(store: memoStore, focusTrigger: focusTrigger)
        }
    }

    private func dismissLoginHint() {
        showLoginHint = false
        UserDefaults.standard.set(true, forKey: "didShowLoginHint")
    }

    private func openLoginItemSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.LoginItems-Settings.extension") {
            NSWorkspace.shared.open(url)
        }
    }

    private func installTabMonitor() {
        tabMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == 48 && event.modifierFlags
                .intersection(.deviceIndependentFlagsMask) == [] {
                switchTab()
                return nil
            }
            return event
        }
    }

    private func removeTabMonitor() {
        if let monitor = tabMonitor {
            NSEvent.removeMonitor(monitor)
            tabMonitor = nil
        }
    }

    private func switchTab() {
        let allTabs = AppTab.allCases
        guard let index = allTabs.firstIndex(of: selectedTab) else { return }
        let nextIndex = (index + 1) % allTabs.count
        selectedTab = allTabs[nextIndex]
    }
}
