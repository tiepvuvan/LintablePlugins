# LintablePlugins

The build-tool and command plugins for [Lintable](https://github.com/tiepvuvan/Lintable),
with a prebuilt `lintable` binary, so adding the plugin downloads one zip and never
compiles swift-syntax.

This package is published from the Lintable repository by its release workflow. Open
issues and pull requests there.

## Swift packages

```swift
dependencies: [
    .package(url: "https://github.com/tiepvuvan/LintablePlugins", from: "0.1.0"),
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
