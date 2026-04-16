import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var panel: FloatingPanel?
    private var hotKeyManager: HotKeyManager?
    private let store = TodoStore()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        setupPanel()
        setupHotKey()
    }

    private func setupPanel() {
        let contentView = ContentView(store: store)
        panel = FloatingPanel(contentView: contentView)
    }

    private func setupHotKey() {
        hotKeyManager = HotKeyManager { [weak self] in
            self?.togglePanel()
        }
        hotKeyManager?.register()
    }

    func togglePanel() {
        guard let panel else { return }
        if panel.isVisible {
            panel.orderOut(nil)
        } else {
            panel.positionTopLeft()
            panel.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
