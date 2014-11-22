# Traversal

This is a Swift framework providing a single collection interface, `ReducibleType`, suitable for representing the traversal of collections.


## Why not `SequenceType`/`GeneratorType`?

Swift has abstractions for representing the traversal of collections: `SequenceType` produces instances of `GeneratorType` which are iterated by repeated calls to `next()`. However, these abstractions have several drawbacks:

1. It’s [fragile to use](http://www.openradar.me/18453000) in practice, owing to its reliance on mutable state. In particular, its interface alone does not provide access to the current element; you can only ever retrieve the next one (mutating the generator in the process).
2. Related to this, there are ad hoc constraints on their used which are not captured in the type system and which may differ between implementations. For example, copies of generators cannot in general be advanced separately, as that may invalidate the other copies. Instead, multiple generators must be retrieved from the base sequence. However, the comments note that even this may not suffice:

	> Any code that uses multiple generators (or `for`…`in` loops) over a single *sequence* should have static knowledge that the specific *sequence* is multi-pass, either because its concrete type is known or because it is constrained to `CollectionType`. Also, the generators must be obtained by distinct calls to the *sequence's* `generate()` method, rather than by copying.

3. _Iteration_ (sequential access by client code calling into API) is generally less efficient than _enumeration_ (sequential access by API calling into client code).

In contrast, Traversal’s `ReducibleType` interface does not depend on mutable state, and provides a consistent and stable basis for both enumeration _and_ iteration at the caller’s discretion.


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
