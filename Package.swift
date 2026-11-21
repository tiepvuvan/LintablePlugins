// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "LintablePlugins",
    products: [
        .plugin(name: "LintableBuildToolPlugin", targets: ["LintableBuildToolPlugin"]),
        .plugin(name: "LintableCommandPlugin", targets: ["LintableCommandPlugin"]),
    ],
    targets: [
        .binaryTarget(name: "LintableBinary", url: "https://github.com/tiepvuvan/Lintable/releases/download/v0.4.0/lintable.artifactbundle.zip", checksum: "95169efb8b3daa59d7a42bf5c1b73c3e5a2f1c7c7085970753c6c195407c471e"),
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
