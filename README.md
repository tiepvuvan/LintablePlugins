# LintablePlugins

The build-tool and command plugins for [Lintable](https://github.com/tiepvuvan/Lintable),
with a prebuilt `lintable` binary, so adding the plugin downloads one zip and never
compiles swift-syntax.

This package is published from the Lintable repository by its release workflow. Open
issues and pull requests there.

## Swift packages

```swift
dependencies: [
    .package(url: "https://github.com/tiepvuvan/LintablePlugins", from: "0.3.0"),
],
targets: [
    .target(
        name: "App",
        plugins: [.plugin(name: "LintableBuildToolPlugin", package: "LintablePlugins")]
    ),
]
```

## Xcode projects

Add `https://github.com/tiepvuvan/LintablePlugins` as a package dependency, then add
`LintableBuildToolPlugin` under each target's Build Phases → Run Build Tool Plug-ins.

## Configuration

The plugin looks for the nearest `.lintable.yml`, from the target's folder up to the
package or project root, and does nothing without one. Run `lintable init` to create
it, then list the rules you want under `rules:`.

It checks the target's Swift files and String Catalogs (`.xcstrings`). It also adds
`LintableReleaseGate.swift` to the target, which is empty unless the config's
`release_condition` and a rule's `release_severity` say a violation should stop
release builds.

## Command plugin

```bash
swift package lintable
```

```bash
swift package lintable --target App
```

In Xcode, right-click the project in the navigator and choose **LintableCommandPlugin**.

## License

MIT.
