import PackageDescription

let package = Package(
    name: "MTMarathon",
    dependencies: [
        .Package(url: "../SwiftCUDA", majorVersion: 0)
    ]
)
