// swift-/Users/osls/Desktop/DataSourcePackage/Package.swifttools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataSourcePackage",
    platforms: [.iOS("13.0")],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DataSourcePackage",
            targets: ["DataSourcePackage"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", branch: "master"),
        .package(name: "Realm", url: "https://github.com/realm/realm-swift", branch: "master"),
        .package(name: "RxSwift", url: "https://github.com/ReactiveX/RxSwift.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DataSourcePackage",
            dependencies: ["Alamofire", "Realm", "RxSwift"]),
    ]
)
