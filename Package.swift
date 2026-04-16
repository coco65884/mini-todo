// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MiniTodo",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "MiniTodo",
            path: "Sources/MiniTodo"
        ),
        .testTarget(
            name: "MiniTodoTests",
            dependencies: ["MiniTodo"],
            path: "Tests/MiniTodoTests"
        ),
    ]
)
