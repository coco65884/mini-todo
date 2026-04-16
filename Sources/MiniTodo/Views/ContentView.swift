import SwiftUI

struct ContentView: View {
    @ObservedObject var store: TodoStore
    var focusTrigger: UUID
    @State private var newTodoTitle = ""
    @State private var showCompleted = false
    @FocusState var isInputFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            inputField
            Divider()
            todoList
            Divider()
            completedToggle
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
        HStack(spacing: 8) {
            Image(systemName: "plus.circle.fill")
                .foregroundStyle(.blue)
            TextField("新しいタスク... (⌘+Enter で登録)", text: $newTodoTitle)
                .textFieldStyle(.plain)
                .focused($isInputFocused)
                .onKeyPress(.return, phases: .down) { keyPress in
                    if keyPress.modifiers.contains(.command) {
                        store.add(title: newTodoTitle)
                        newTodoTitle = ""
                        return .handled
                    }
                    return .ignored
                }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    // MARK: - List

    private var todoList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                if !store.pendingPreviousDays.isEmpty {
                    sectionHeader("前日以前")
                    ForEach(store.pendingPreviousDays) { item in
                        todoRow(item)
                    }
                }

                sectionHeader("今日")
                if store.todayItems.isEmpty && store.pendingPreviousDays.isEmpty {
                    Text("タスクはありません")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                }
                ForEach(store.todayItems) { item in
                    todoRow(item)
                }

                if showCompleted && !store.completedItems.isEmpty {
                    Divider().padding(.vertical, 4)
                    sectionHeader("消化済み")
                    ForEach(store.completedItems) { item in
                        todoRow(item)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: - Completed Toggle

    private var completedToggle: some View {
        Button {
            showCompleted.toggle()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: showCompleted
                    ? "checkmark.circle.fill"
                    : "checkmark.circle")
                Text(showCompleted ? "消化済みを非表示" : "消化済みを表示")
                    .font(.caption)
            }
            .foregroundStyle(showCompleted ? .green : .secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 12)
            .padding(.top, 8)
            .padding(.bottom, 2)
    }

    private func todoRow(_ item: TodoItem) -> some View {
        HStack(spacing: 8) {
            Button {
                store.toggleCompletion(item)
            } label: {
                Image(systemName: item.isCompleted
                    ? "checkmark.circle.fill"
                    : "circle")
                    .foregroundStyle(item.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)

            Text(item.title)
                .strikethrough(item.isCompleted)
                .foregroundStyle(item.isCompleted ? .secondary : .primary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 3)
        .contentShape(Rectangle())
    }
}
