import SwiftUI

struct MemoView: View {
    @ObservedObject var store: MemoStore
    var focusTrigger: UUID
    @State private var inputContent = ""
    @FocusState var isInputFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            inputField
            Divider()
            memoList
        }
        .onAppear {
            isInputFocused = true
        }
        .onChange(of: focusTrigger) { _, _ in
            isInputFocused = true
        }
    }

    // MARK: - Input

    private var inputField: some View {
        TextField("新しいメモ... (⌘+Enter で登録)", text: $inputContent, axis: .vertical)
            .textFieldStyle(.plain)
            .lineLimit(1...5)
            .focused($isInputFocused)
            .onKeyPress(.return, phases: .down) { keyPress in
                if keyPress.modifiers.contains(.command) {
                    store.add(content: inputContent)
                    inputContent = ""
                    return .handled
                }
                return .ignored
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
    }

    // MARK: - List

    private var memoList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                if store.items.isEmpty {
                    Text("メモはありません")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                }
                ForEach(store.items) { item in
                    memoRow(item)
                    Divider().padding(.horizontal, 12)
                }
            }
            .padding(.vertical, 4)
        }
    }

    private func memoRow(_ item: MemoItem) -> some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.content)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                Text(formatDate(item.updatedAt))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            Button {
                store.delete(item)
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.red.opacity(0.7))
                    .font(.caption)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture {
            inputContent = item.content
            store.delete(item)
            isInputFocused = true
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d HH:mm"
        return formatter.string(from: date)
    }
}
