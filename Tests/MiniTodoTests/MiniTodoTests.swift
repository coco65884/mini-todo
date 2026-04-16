import XCTest
@testable import MiniTodo

final class TodoItemTests: XCTestCase {
    func testInitDefaults() {
        let item = TodoItem(title: "Test")
        XCTAssertEqual(item.title, "Test")
        XCTAssertFalse(item.isCompleted)
        XCTAssertNil(item.completedAt)
    }

    func testIsCreatedToday() {
        let today = TodoItem(title: "Today")
        XCTAssertTrue(today.isCreatedToday)

        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let yesterday = TodoItem(title: "Yesterday", createdAt: yesterdayDate)
        XCTAssertFalse(yesterday.isCreatedToday)
    }
}

final class TodoStoreTests: XCTestCase {
    private func makeTempStore() -> TodoStore {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("json")
        return TodoStore(fileURL: url)
    }

    func testAddItem() {
        let store = makeTempStore()
        store.add(title: "Buy milk")
        XCTAssertEqual(store.items.count, 1)
        XCTAssertEqual(store.items.first?.title, "Buy milk")
    }

    func testAddEmptyTitleIsIgnored() {
        let store = makeTempStore()
        store.add(title: "   ")
        XCTAssertTrue(store.items.isEmpty)
    }

    func testToggleCompletion() {
        let store = makeTempStore()
        store.add(title: "Task")
        let item = store.items[0]

        store.toggleCompletion(item)
        XCTAssertTrue(store.items[0].isCompleted)
        XCTAssertNotNil(store.items[0].completedAt)

        store.toggleCompletion(store.items[0])
        XCTAssertFalse(store.items[0].isCompleted)
        XCTAssertNil(store.items[0].completedAt)
    }

    func testDelete() {
        let store = makeTempStore()
        store.add(title: "A")
        store.add(title: "B")
        let itemA = store.items[0]

        store.delete(itemA)
        XCTAssertEqual(store.items.count, 1)
        XCTAssertEqual(store.items[0].title, "B")
    }

    func testFilteredLists() {
        let store = makeTempStore()
        store.add(title: "Today task")

        XCTAssertEqual(store.todayItems.count, 1)
        XCTAssertTrue(store.pendingPreviousDays.isEmpty)
        XCTAssertTrue(store.completedItems.isEmpty)

        store.toggleCompletion(store.items[0])
        XCTAssertTrue(store.todayItems.isEmpty)
        XCTAssertEqual(store.completedItems.count, 1)
    }

    func testPersistence() {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("json")

        let store1 = TodoStore(fileURL: url)
        store1.add(title: "Persist me")

        let store2 = TodoStore(fileURL: url)
        XCTAssertEqual(store2.items.count, 1)
        XCTAssertEqual(store2.items.first?.title, "Persist me")

        try? FileManager.default.removeItem(at: url)
    }
}

// MARK: - MemoItem Tests

final class MemoItemTests: XCTestCase {
    func testTitle() {
        let memo = MemoItem(content: "First line\nSecond line")
        XCTAssertEqual(memo.title, "First line")
    }

    func testTitleSingleLine() {
        let memo = MemoItem(content: "Only one line")
        XCTAssertEqual(memo.title, "Only one line")
    }
}

// MARK: - MemoStore Tests

final class MemoStoreTests: XCTestCase {
    private func makeTempStore() -> MemoStore {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("json")
        return MemoStore(fileURL: url)
    }

    func testAddMemo() {
        let store = makeTempStore()
        store.add(content: "Hello memo")
        XCTAssertEqual(store.items.count, 1)
        XCTAssertEqual(store.items.first?.content, "Hello memo")
    }

    func testAddEmptyIsIgnored() {
        let store = makeTempStore()
        store.add(content: "   ")
        XCTAssertTrue(store.items.isEmpty)
    }

    func testAddInsertsAtTop() {
        let store = makeTempStore()
        store.add(content: "First")
        store.add(content: "Second")
        XCTAssertEqual(store.items[0].content, "Second")
        XCTAssertEqual(store.items[1].content, "First")
    }

    func testUpdateMemo() {
        let store = makeTempStore()
        store.add(content: "Original")
        let item = store.items[0]

        store.update(item, content: "Updated")
        XCTAssertEqual(store.items[0].content, "Updated")
    }

    func testDeleteMemo() {
        let store = makeTempStore()
        store.add(content: "A")
        store.add(content: "B")
        let itemB = store.items[0] // "B" is at top

        store.delete(itemB)
        XCTAssertEqual(store.items.count, 1)
        XCTAssertEqual(store.items[0].content, "A")
    }

    func testPersistence() {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("json")

        let store1 = MemoStore(fileURL: url)
        store1.add(content: "Persist memo")

        let store2 = MemoStore(fileURL: url)
        XCTAssertEqual(store2.items.count, 1)
        XCTAssertEqual(store2.items.first?.content, "Persist memo")

        try? FileManager.default.removeItem(at: url)
    }
}
