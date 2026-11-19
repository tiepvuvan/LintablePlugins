import Foundation
import PackagePlugin

@main
struct LintableBuildToolPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard let target = target as? SourceModuleTarget else { return [] }
        return try LintCommands.make(
            tool: context.tool(named: "lintable-cli").url,
            target: LintTarget(
                name: target.name,
                files: target.sourceFiles(withSuffix: "swift").map(\.url),
                searchFrom: target.directoryURL,
                root: context.package.directoryURL
            ),
            workDirectory: context.pluginWorkDirectoryURL
        )
    }
}

#if canImport(XcodeProjectPlugin)
    import XcodeProjectPlugin

    extension LintableBuildToolPlugin: XcodeBuildToolPlugin {
        func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
            try LintCommands.make(
                tool: context.tool(named: "lintable-cli").url,
                target: LintTarget(
                    name: target.displayName,
                    files: target.inputFiles.filter { $0.url.pathExtension == "swift" }.map(\.url),
                    searchFrom: context.xcodeProject.directoryURL,
                    root: context.xcodeProject.directoryURL
                ),
                workDirectory: context.pluginWorkDirectoryURL
            )
        }
    }
#endif

struct LintTarget {
    let name: String
    let files: [URL]
    let searchFrom: URL
    let root: URL
}

enum LintCommands {
    static func make(tool: URL, target: LintTarget, workDirectory: URL) throws -> [Command] {
        guard !target.files.isEmpty, let configuration = nearestConfiguration(from: target.searchFrom, root: target.root) else {
            return []
        }
        try FileManager.default.createDirectory(at: workDirectory, withIntermediateDirectories: true)
        let fileList = workDirectory.appendingPathComponent("files.txt")
        try Data(target.files.map(\.path).sorted().joined(separator: "\n").utf8).write(to: fileList)
        return [
            .prebuildCommand(
                displayName: "Lintable \(target.name)",
                executable: tool,
                arguments: [
                    "lint",
                    "--config", configuration.path,
                    "--reporter", "xcode",
                    "--files-from", fileList.path,
                    "--cache-path", workDirectory.appendingPathComponent("Cache").path,
                ],
                outputFilesDirectory: workDirectory.appendingPathComponent("Output")
            ),
        ]
    }

    static func nearestConfiguration(from start: URL, root: URL) -> URL? {
        let rootPath = root.standardizedFileURL.path
        var current = start.standardizedFileURL
        while true {
            let candidate = current.appendingPathComponent(".lintable.yml")
            if FileManager.default.fileExists(atPath: candidate.path) {
                return candidate
            }
            let parent = current.deletingLastPathComponent()
            if current.path == rootPath || parent.path == current.path {
                return nil
            }
            current = parent
        }
    }
}
