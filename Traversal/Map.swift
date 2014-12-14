//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns a reducer mapping the elements of `reducible` with `f`.
public func map<Base: ReducibleType, T>(reducible: Base, map: Base.Element -> T) -> Map<Base, T> {
	return Map(reducible, map)
}


/// A reducer which maps the elements of the underlying reducible.
public struct Map<Base: ReducibleType, T>: ReducibleType {
	// MARK: Constructors

	/// Constructs a `Map` with a given `reducible` and `map` function.
	public init(_ reducible: Base, _ map: Base.Element -> T) {
		self.reducible = reducible
		self.map = map
	}


	// MARK: ReducibleType

	public func reducer<Result>() -> Reducible<Map, Result, T>.Enumerator -> Reducible<Map, Result, T>.Enumerator {
		return { recur in
			{ collection, initial, combine in
				(collection.reducible.reducer()) { reducible, initial, _ in
					recur(Map(reducible, self.map), initial, combine)
				} (collection.reducible, initial) {
					combine($0, collection.map($1))
				}
			}
		}
	}


	// MARK: Private

	private let reducible: Base
	private let map: Base.Element -> T
}
