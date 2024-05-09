// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "KKLogger",
  products: [
    // Produkty definiują pliki wykonywalne i biblioteki tworzone przez pakiet, dzięki czemu są one widoczne dla innych pakietów.
    .library(
      name: "KKLogger",
      targets: ["KKLogger"]),
  ],
  dependencies: [
    .package(url: "https://github.com/DaveWoodCom/XCGLogger.git", from: "7.0.1")
  ],
  targets: [
    // Cele to podstawowe elementy składowe pakietu, definiujące moduł lub zestaw testów.
    // Cele mogą zależeć od innych celów w tym pakiecie i produktów od zależności.
    .target(
      name: "KKLogger",
      dependencies: [ "XCGLogger" ],
      path: "Sources",
      resources: [
      
      ]
    ),
//    .testTarget(
//      name: "KKLoggerTests",
//      dependencies: ["KKLogger"]),
  ]
)
