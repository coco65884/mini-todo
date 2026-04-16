import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var panel: FloatingPanel?
    private var hotKeyManager: HotKeyManager?
    private var settingsWindow: NSWindow?
    private let store = TodoStore()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        setupPanel()
        setupHotKey()
        setupStatusBarMenu()
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

    private func setupStatusBarMenu() {
        let statusItem = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.squareLength
        )
        if let button = statusItem.button {
            button.image = NSImage(
                systemSymbolName: "checklist",
                accessibilityDescription: "Mini Todo"
            )
        }

        let menu = NSMenu()
        menu.addItem(
            NSMenuItem(
                title: "設定...",
                action: #selector(openSettings),
                keyEquivalent: ","
            )
        )
        menu.addItem(.separator())
        menu.addItem(
            NSMenuItem(
                title: "終了",
                action: #selector(NSApplication.terminate(_:)),
                keyEquivalent: "q"
            )
        )
        statusItem.menu = menu
    }

    @objc private func openSettings() {
        if let settingsWindow, settingsWindow.isVisible {
            settingsWindow.makeKeyAndOrderFront(nil)
            return
        }

        let settingsView = SettingsView { [weak self] newConfig in
            self?.hotKeyManager?.register(config: newConfig)
        }

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 280, height: 300),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Mini Todo 設定"
        window.contentView = NSHostingView(rootView: settingsView)
        window.center()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        settingsWindow = window
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
