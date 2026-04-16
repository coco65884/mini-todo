import AppKit

let iconsetDir = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "Assets/AppIcon.iconset"

try? FileManager.default.createDirectory(
    atPath: iconsetDir,
    withIntermediateDirectories: true
)

let sizes: [(Int, Int)] = [
    (16, 1), (16, 2), (32, 1), (32, 2),
    (128, 1), (128, 2), (256, 1), (256, 2),
    (512, 1), (512, 2)
]

for (size, scale) in sizes {
    let px = size * scale
    let img = NSImage(size: NSSize(width: px, height: px))
    img.lockFocus()

    let rect = NSRect(x: 0, y: 0, width: px, height: px)
    let path = NSBezierPath(
        roundedRect: rect,
        xRadius: CGFloat(px) * 0.2,
        yRadius: CGFloat(px) * 0.2
    )
    NSColor(red: 0.29, green: 0.56, blue: 0.85, alpha: 1.0).setFill()
    path.fill()

    let attrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: CGFloat(px) * 0.5, weight: .bold),
        .foregroundColor: NSColor.white
    ]
    let text = "✓" as NSString
    let textSize = text.size(withAttributes: attrs)
    let textPoint = NSPoint(
        x: (CGFloat(px) - textSize.width) / 2,
        y: (CGFloat(px) - textSize.height) / 2
    )
    text.draw(at: textPoint, withAttributes: attrs)

    img.unlockFocus()

    guard let tiff = img.tiffRepresentation,
          let rep = NSBitmapImageRep(data: tiff),
          let png = rep.representation(using: .png, properties: [:])
    else { continue }

    let suffix = scale > 1 ? "@\(scale)x" : ""
    let filename = "icon_\(size)x\(size)\(suffix).png"
    let url = URL(fileURLWithPath: iconsetDir).appendingPathComponent(filename)
    try? png.write(to: url)
}
print("Icons generated in \(iconsetDir)")
