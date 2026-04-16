import Foundation

final class MemoStore: ObservableObject {
    @Published private(set) var items: [MemoItem] = []

    private let fileURL: URL

    init(fileURL: URL? = nil) {
        self.fileURL = fileURL ?? Self.defaultFileURL()
        self.items = load()
    }

    // MARK: - CRUD

    func add(content: String) {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        items.insert(MemoItem(content: trimmed), at: 0)
        save()
    }

    func update(_ item: MemoItem, content: String) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        items[index].content = trimmed
        items[index].updatedAt = Date()
        save()
    }

    func delete(_ item: MemoItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    // MARK: - Persistence

    private static func defaultFileURL() -> URL {
        let appSupport = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first!
        let dir = appSupport.appendingPathComponent("MiniTodo", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("memos.json")
    }

    private func load() -> [MemoItem] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([MemoItem].self, from: data)
        } catch {
            return []
        }
    }

    private func save() {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(items)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            // Silently fail
        }
    }
}
