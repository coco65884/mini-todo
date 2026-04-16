import AppKit
import SwiftUI

final class FloatingPanel: NSPanel {
    init(contentView: some View) {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 400),
            styleMask: [.titled, .closable, .fullSizeContentView, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.isMovableByWindowBackground = true
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = true
        self.becomesKeyOnlyIfNeeded = false

        let hostingView = NSHostingView(rootView: contentView)
        self.contentView = hostingView

        positionTopLeft()
    }

    func positionTopLeft() {
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.visibleFrame
        let panelFrame = self.frame
        let origin = NSPoint(
            x: screenFrame.minX + 16,
            y: screenFrame.maxY - panelFrame.height - 16
        )
        self.setFrameOrigin(origin)
    }

    override var canBecomeKey: Bool { true }
}
