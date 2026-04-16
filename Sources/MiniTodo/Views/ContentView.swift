import SwiftUI

struct ContentView: View {
    @ObservedObject var store: TodoStore
    @State private var newTodoTitle = ""
    @State private var showCompleted = false
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
            Divider()
            inputField
            Divider()
            todoList
        }
        .frame(width: 320, height: 400)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            isInputFocused = true
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack {
            Text("Mini Todo")
                .font(.headline)
            Spacer()
            Button {
                showCompleted.toggle()
            } label: {
                Image(systemName: showCompleted
                    ? "checkmark.circle.fill"
                    : "checkmark.circle")
                    .foregroundStyle(showCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)
            .help(showCompleted ? "消化済みを非表示" : "消化済みを表示")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    // MARK: - Input

    private var inputField: some View {
        HStack(spacing: 8) {
            Image(systemName: "plus.circle.fill")
                .foregroundStyle(.blue)
            TextField("新しいタスク...", text: $newTodoTitle)
                .textFieldStyle(.plain)
                .focused($isInputFocused)
                .onSubmit {
                    store.add(title: newTodoTitle)
                    newTodoTitle = ""
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
                .lineLimit(1)

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 3)
        .contentShape(Rectangle())
    }
}
