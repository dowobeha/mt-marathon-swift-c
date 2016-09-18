import PackageDescription

let package = Package(
    name: "MTMarathon",
    dependencies: [
        .Package(url: "https://github.com/rxwei/SwiftCUDA", majorVersion: 1)
    ],
    exclude: [
        "unused", "doc"
    ]
)
