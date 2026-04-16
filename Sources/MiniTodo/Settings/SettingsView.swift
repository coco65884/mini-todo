import SwiftUI

struct SettingsView: View {
    @State private var config = KeyConfig.load()
    var onSave: (KeyConfig) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ホットキー設定")
                .font(.headline)

            GroupBox("修飾キー") {
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("⌃ Control", isOn: $config.useControl)
                    Toggle("⌥ Option", isOn: $config.useOption)
                    Toggle("⇧ Shift", isOn: $config.useShift)
                    Toggle("⌘ Command", isOn: $config.useCommand)
                }
                .padding(4)
            }

            GroupBox("キー") {
                Picker("キー", selection: $config.keyCode) {
                    ForEach(KeyConfig.availableKeys, id: \.code) { key in
                        Text(key.name).tag(key.code)
                    }
                }
                .labelsHidden()
                .padding(4)
            }

            HStack {
                Text("現在: \(config.displayString)")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                Spacer()
                Button("保存") {
                    config.save()
                    onSave(config)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!config.useControl
                    && !config.useOption
                    && !config.useShift
                    && !config.useCommand)
            }
        }
        .padding(20)
        .frame(width: 280)
    }
}
