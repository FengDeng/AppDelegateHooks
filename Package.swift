// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppDelegateHooks",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "AppDelegateHooks",
            targets: ["AppDelegateHooks"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/steipete/Aspects.git", Package.Dependency.Requirement.branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "AppDelegateHooks",
            dependencies: ["Aspects"]),
        .testTarget(
            name: "AppDelegateHooksTests",
            dependencies: ["AppDelegateHooks"]),
    ]
)
