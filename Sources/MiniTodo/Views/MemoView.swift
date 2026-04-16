import SwiftUI

struct MemoView: View {
    @ObservedObject var store: MemoStore
    @State private var newMemoContent = ""
    @State private var editingMemoID: UUID?
    @State private var editingContent = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            inputField
            Divider()
            memoList
        }
        .onAppear {
            isInputFocused = true
        }
    }

    // MARK: - Input

    private var inputField: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .topLeading) {
                if newMemoContent.isEmpty {
                    Text("新しいメモ... (Shift+Enter で登録)")
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 6)
                }
                TextEditor(text: $newMemoContent)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .focused($isInputFocused)
                    .frame(minHeight: 40, maxHeight: 80)
                    .onKeyPress(.return, phases: .down) { keyPress in
                        if keyPress.modifiers.contains(.shift) {
                            store.add(content: newMemoContent)
                            newMemoContent = ""
                            return .handled
                        }
                        return .ignored
                    }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
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
                    if editingMemoID == item.id {
                        editRow(item)
                    } else {
                        memoRow(item)
                    }
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
                    .lineLimit(5)
                Text(formatDate(item.updatedAt))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            VStack(spacing: 4) {
                Button {
                    editingMemoID = item.id
                    editingContent = item.content
                } label: {
                    Image(systemName: "pencil")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
                .buttonStyle(.plain)

                Button {
                    store.delete(item)
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red.opacity(0.7))
                        .font(.caption)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }

    private func editRow(_ item: MemoItem) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            TextEditor(text: $editingContent)
                .font(.body)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 40, maxHeight: 100)
                .onKeyPress(.return, phases: .down) { keyPress in
                    if keyPress.modifiers.contains(.shift) {
                        store.update(item, content: editingContent)
                        editingMemoID = nil
                        return .handled
                    }
                    return .ignored
                }

            HStack {
                Text("Shift+Enter で保存")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                Spacer()
                Button("キャンセル") {
                    editingMemoID = nil
                }
                .font(.caption)
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.accentColor.opacity(0.05))
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d HH:mm"
        return formatter.string(from: date)
    }
}
