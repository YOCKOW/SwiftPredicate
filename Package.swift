// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Predicate",
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .library(name: "SwiftPredicate", type:.dynamic, targets: ["Predicate"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(url:"https://github.com/YOCKOW/SwiftRanges", from: "3.0.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages which this package depends on.
    .target(name: "Predicate", dependencies: ["SwiftRanges"]),
    .target(name: "PredicateTestSupporters", dependencies: ["Predicate"]),
    .testTarget(name: "PredicateTests", dependencies: ["Predicate", "PredicateTestSupporters"]),
  ],
  swiftLanguageVersions: [.v4, .v4_2, .v5]
)

