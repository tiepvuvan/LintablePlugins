// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "LintablePlugins",
    products: [
        .plugin(name: "LintableBuildToolPlugin", targets: ["LintableBuildToolPlugin"]),
        .plugin(name: "LintableCommandPlugin", targets: ["LintableCommandPlugin"]),
    ],
    targets: [
        .binaryTarget(name: "LintableBinary", url: "https://github.com/tiepvuvan/Lintable/releases/download/v0.3.0/lintable.artifactbundle.zip", checksum: "392354c3fce22bdbd4fdb9304c6a758444f55da90bd0b91799b0292948f7fac6"),
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
