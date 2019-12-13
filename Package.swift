// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FormDataEncoder",
    products: [
      .library(name: "FormDataEncoder", targets: ["FormDataEncoder"]),
    ],
    targets: [
      .target(name: "FormDataEncoder", path: "Sources"),
      .testTarget(name: "FormDataEncoderTests", dependencies: ["FormDataEncoder"], path: "Tests"),
    ]
)
