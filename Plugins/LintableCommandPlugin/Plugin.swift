import Foundation
import PackagePlugin

@main
struct LintableCommandPlugin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        var extractor = ArgumentExtractor(arguments)
        let names = extractor.extractOption(named: "target")
        let targets = names.isEmpty ? context.package.targets : try context.package.targets(named: names)
        let files = targets
            .compactMap { $0 as? SourceModuleTarget }
            .flatMap { $0.sourceFiles.map(\.url).filter { ["swift", "xcstrings"].contains($0.pathExtension) } }
        try LintRun.perform(
            tool: context.tool(named: "lintable-cli").url,
            files: files,
            root: context.package.directoryURL,
            workDirectory: context.pluginWorkDirectoryURL,
            extraArguments: extractor.remainingArguments
        )
    }
}

#if canImport(XcodeProjectPlugin)
    import XcodeProjectPlugin

    extension LintableCommandPlugin: XcodeCommandPlugin {
        func performCommand(context: XcodePluginContext, arguments: [String]) throws {
            var extractor = ArgumentExtractor(arguments)
            let names = extractor.extractOption(named: "target")
            let files = context.xcodeProject.targets
                .filter { names.isEmpty || names.contains($0.displayName) }
                .flatMap { $0.inputFiles.map(\.url).filter { ["swift", "xcstrings"].contains($0.pathExtension) } }
            try LintRun.perform(
                tool: context.tool(named: "lintable-cli").url,
                files: files,
                root: context.xcodeProject.directoryURL,
                workDirectory: context.pluginWorkDirectoryURL,
                extraArguments: extractor.remainingArguments
            )
        }
    }
#endif

enum LintRun {
    static func perform(tool: URL, files: [URL], root: URL, workDirectory: URL, extraArguments: [String]) throws {
        let configuration = root.appendingPathComponent(".lintable.yml")
        guard FileManager.default.fileExists(atPath: configuration.path) else {
            Diagnostics.error("No .lintable.yml at \(root.path). Run `lintable init` there to create one.")
            return
        }
        try FileManager.default.createDirectory(at: workDirectory, withIntermediateDirectories: true)
        let fileList = workDirectory.appendingPathComponent("files.txt")
        try Data(files.map(\.path).sorted().joined(separator: "\n").utf8).write(to: fileList)
        let process = Process()
        process.executableURL = tool
        process.arguments = [
            "lint",
            "--config", configuration.path,
            "--reporter", "summary",
            "--files-from", fileList.path,
            "--no-cache",
        ] + extraArguments
        try process.run()
        process.waitUntilExit()
        if process.terminationStatus != 0 {
            Diagnostics.error("Lintable exited with status \(process.terminationStatus).")
        }
    }
}
