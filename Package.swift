// swift-tools-version:4.1
import PackageDescription

let package = Package(
    name: "BA_Backend",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0-rc"),
<<<<<<< HEAD
        .package(url: "https://github.com/MihaelIsaev/FluentQuery.git", from: "0.4.2")
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentPostgreSQL", "Vapor", "FluentQuery" ]),
=======
        
        .package(url: "https://github.com/MihaelIsaev/FluentQuery.git", from: "0.4.2")

    ],
    targets: [
        .target(name: "App", dependencies: ["FluentPostgreSQL", "Vapor", "FluentQuery"]),
>>>>>>> origin/master
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]//,
    //swiftLanguageVersions: [.v4, .4_1]
)
