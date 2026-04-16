import Carbon
import Foundation

struct KeyConfig: Codable, Equatable {
    var useControl: Bool
    var useOption: Bool
    var useShift: Bool
    var useCommand: Bool
    var keyCode: Int

    static let `default` = KeyConfig(
        useControl: true,
        useOption: true,
        useShift: false,
        useCommand: false,
        keyCode: Int(kVK_ANSI_T)
    )

    var carbonModifiers: UInt32 {
        var mods: UInt32 = 0
        if useControl { mods |= UInt32(controlKey) }
        if useOption { mods |= UInt32(optionKey) }
        if useShift { mods |= UInt32(shiftKey) }
        if useCommand { mods |= UInt32(cmdKey) }
        return mods
    }

    var displayString: String {
        var parts: [String] = []
        if useControl { parts.append("⌃") }
        if useOption { parts.append("⌥") }
        if useShift { parts.append("⇧") }
        if useCommand { parts.append("⌘") }
        parts.append(Self.keyName(for: keyCode))
        return parts.joined()
    }

    // swiftlint:disable:next cyclomatic_complexity
    static func keyName(for code: Int) -> String {
        switch code {
        case kVK_ANSI_A: return "A"
        case kVK_ANSI_B: return "B"
        case kVK_ANSI_C: return "C"
        case kVK_ANSI_D: return "D"
        case kVK_ANSI_E: return "E"
        case kVK_ANSI_F: return "F"
        case kVK_ANSI_G: return "G"
        case kVK_ANSI_H: return "H"
        case kVK_ANSI_I: return "I"
        case kVK_ANSI_J: return "J"
        case kVK_ANSI_K: return "K"
        case kVK_ANSI_L: return "L"
        case kVK_ANSI_M: return "M"
        case kVK_ANSI_N: return "N"
        case kVK_ANSI_O: return "O"
        case kVK_ANSI_P: return "P"
        case kVK_ANSI_Q: return "Q"
        case kVK_ANSI_R: return "R"
        case kVK_ANSI_S: return "S"
        case kVK_ANSI_T: return "T"
        case kVK_ANSI_U: return "U"
        case kVK_ANSI_V: return "V"
        case kVK_ANSI_W: return "W"
        case kVK_ANSI_X: return "X"
        case kVK_ANSI_Y: return "Y"
        case kVK_ANSI_Z: return "Z"
        default: return "?"
        }
    }

    static let availableKeys: [(name: String, code: Int)] = [
        ("A", kVK_ANSI_A), ("B", kVK_ANSI_B), ("C", kVK_ANSI_C),
        ("D", kVK_ANSI_D), ("E", kVK_ANSI_E), ("F", kVK_ANSI_F),
        ("G", kVK_ANSI_G), ("H", kVK_ANSI_H), ("I", kVK_ANSI_I),
        ("J", kVK_ANSI_J), ("K", kVK_ANSI_K), ("L", kVK_ANSI_L),
        ("M", kVK_ANSI_M), ("N", kVK_ANSI_N), ("O", kVK_ANSI_O),
        ("P", kVK_ANSI_P), ("Q", kVK_ANSI_Q), ("R", kVK_ANSI_R),
        ("S", kVK_ANSI_S), ("T", kVK_ANSI_T), ("U", kVK_ANSI_U),
        ("V", kVK_ANSI_V), ("W", kVK_ANSI_W), ("X", kVK_ANSI_X),
        ("Y", kVK_ANSI_Y), ("Z", kVK_ANSI_Z)
    ]

    // MARK: - Persistence

    private static let userDefaultsKey = "hotKeyConfig"

    static func load() -> KeyConfig {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let config = try? JSONDecoder().decode(KeyConfig.self, from: data)
        else {
            return .default
        }
        return config
    }

    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: Self.userDefaultsKey)
        }
    }
}
