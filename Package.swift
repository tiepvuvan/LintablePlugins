// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "LintablePlugins",
    products: [
        .plugin(name: "LintableBuildToolPlugin", targets: ["LintableBuildToolPlugin"]),
        .plugin(name: "LintableCommandPlugin", targets: ["LintableCommandPlugin"]),
    ],
    targets: [
        .binaryTarget(name: "LintableBinary", url: "https://github.com/tiepvuvan/Lintable/releases/download/v0.1.0/lintable.artifactbundle.zip", checksum: "59f3729df4f050928ec4fbe8a9a58c48e2b3c2d3f1f49127c69365a0cf7776e8"),
        .plugin(
            name: "LintableBuildToolPlugin",
            capability: .buildTool(),
            dependencies: ["LintableBinary"]
        ),
        .plugin(
            name: "LintableCommandPlugin",
            capability: .command(intent: .custom(verb: "lintable", description: "Check Swift files with Lintable.")),
            dependencies: ["LintableBinary"]
        ),
    ]
)
