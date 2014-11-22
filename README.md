# Traversal

This is a Swift framework providing a single collection interface, `ReducibleType`, suitable for representing the traversal of collections.


## Building Traversal

1. Check out this repository on your Mac:

  ```bash
  git clone https://github.com/robrix/Traversal.git
  ```

2. Check out its dependencies:

	```bash
	git submodule update --init --recursive
	```

3. Open `Traversal.xcworkspace`.
4. Build the `Traversal` target.


## Integrating Traversal

1. Add this repository as a submodule and check out its dependencies, and/or [add it to your Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile) if you’re using [carthage](https://github.com/Carthage/Carthage/) to manage your dependencies.
2. Drag `Traversal.xcodeproj` into your project or workspace, and do the same with its dependencies (i.e. the other `.xcodeproj` files included in `Traversal.xcworkspace`). NB: `Traversal.xcworkspace` is for standalone development of Traversal, while `Traversal.xcodeproj` is for targets using Traversal as a dependency.
3. Link your target against `Traversal.framework` and each of the dependency frameworks.
4. Application targets should ensure that the framework gets copied into their application bundle. (Framework targets should instead require the application linking them to include Traversal and its dependencies.)
