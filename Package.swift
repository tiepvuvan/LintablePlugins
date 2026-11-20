// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "LintablePlugins",
    products: [
        .plugin(name: "LintableBuildToolPlugin", targets: ["LintableBuildToolPlugin"]),
        .plugin(name: "LintableCommandPlugin", targets: ["LintableCommandPlugin"]),
    ],
    targets: [
        .binaryTarget(name: "LintableBinary", url: "https://github.com/tiepvuvan/Lintable/releases/download/v0.2.0/lintable.artifactbundle.zip", checksum: "ee51269e4903f8d35bd6e2f14bda0d49a4e0b0cfb49fd7114f318c0114f6dc88"),
        .plugin(
            name: "LintableBuildToolPlugin",
            capability: .buildTool(),
            dependencies: ["LintableBinary"]
        ),
        .plugin(
            name: "LintableCommandPlugin",
            capability: .command(intent: .custom(verb: "lintable", description: "Check Swift files and String Catalogs with Lintable.")),
            dependencies: ["LintableBinary"]
        ),
    ]
)
