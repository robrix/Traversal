# Traversal

This is a Swift framework providing a single collection interface, `ReducibleType`, suitable for representing the traversal of collections.


## Why Traversal?

- Simplicity: one protocol, `ReducibleType`, provides both enumeration and iteration.
- Ease of use: enumerate with `reduce` & iterate with `Stream`.
- Interoperability: `ReducibleOf` makes a reducible from `SequenceType`; [`sequence(…)`](https://github.com/robrix/Traversal/pull/20) (in development) supports `for`…`in` (and other clients of `SequenceType`) with any `ReducibleType`.
- Ease of adoption: `Stream`, `ReducibleOf`, & `sequence` support any `SequenceType` provider or client; `ReducibleType` is similar to recursive `reduce`.
- Stability: `Stream` is pure; retrieving the current element does not advance/mutate the stream; memoizes, avoiding repeated effects in impure producers.
- Scope: `Stream` evaluates lazily; `reduce` can be halted early; supports unbounded collections.


## Why not `SequenceType`/`GeneratorType`?

Swift’s `SequenceType` & `GeneratorType` interfaces support sequential traversal. However, they have several key drawbacks:

1. [Fragility](http://www.openradar.me/18453000): *requires* mutable state; no access to the current element without mutating.
2. Difficulty of adoption: `SequenceType` can be hard to implement; requirement to mutate makes debugging harder.
3. Difficulty of use: advancing is subtle; correct backtracking requires (essentially) `Stream`; no access to the current element without mutating.
4. Complexity: ad hoc constraints which the compiler cannot enforce; constraints may differ between implementations; copies of generators are legal but should not be advanced separately; untenable promotion to even more complex `CollectionType` instead; per the comments:

	> Any code that uses multiple generators (or `for`…`in` loops) over a single *sequence* should have static knowledge that the specific *sequence* is multi-pass, either because its concrete type is known or because it is constrained to `CollectionType`. Also, the generators must be obtained by distinct calls to the *sequence's* `generate()` method, rather than by copying.

5. Poor locality of reference: _Iteration_ (sequential access by client code calling into API) is generally less efficient than _enumeration_ (sequential access by API calling into client code).

In contrast, Traversal’s `ReducibleType` interface does not depend on mutable state, enabling pure implementations, and provides a consistent and reliable basis for both enumeration _and_ iteration at the caller’s discretion, with only a single method to implement.


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
