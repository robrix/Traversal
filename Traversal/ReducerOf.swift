//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A reducible over other reducibles.
///
/// This is a meta-reducer used to implement `flattenMap`, `map`, `filter`, and `concat`.
public struct ReducerOf<Base: ReducibleType, T: ReducibleType>: ReducibleType, Printable {
	// MARK: Lifecycle

	/// Initializes with a base `reducible` and a `map` from the elements of `reducible` to some inhabitant of `ReducibleType`.
	public init(_ reducible: Base, _ map: Base.Element -> T) {
		self.reducible = reducible
		self.map = map
	}


	// MARK: ReducibleType

	public func reducer<Result>() -> Reducible<ReducerOf, Result, T.Element>.Enumerator -> Reducible<ReducerOf, Result, T.Element>.Enumerator {
		return { recur in
			// In order to reduce `reducible`, we have to pass it a `recur` function which calls the one which this function has been called with. We can’t just pass in `combine` because the element type of `reducible` does not match the element type of `self` (in the general case). However, we don’t want to generate a new function with every step, since that would be wasteful (and surprising). Therefore, we produce the function on the first step only. I’m discontent with this implementation, but it will have to do for now.
			{ collection, initial, combine in
				(collection.reducible.reducer()) { reducible, initial, _ in
					recur(ReducerOf(reducible, collection.map), initial, combine)
				} (collection.reducible, initial) {
					.right(Traversal.reduce(collection.map($1), $0, combine))
				}
			}
		}
	}


	// MARK: Printable

	public var description: String {
		return "ReducerOf(\(reducible))"
	}


	// MARK: Private

	private let reducible: Base
	private let map: Base.Element -> T
}
