//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct MapReducibleView<Base: ReducibleType, T>: ReducibleType {
	// MARK: Lifecycle

	/// Initializes with a reducible and a function mapping the reducible’s elements to the constructed instance’s elements.
	private init(reducible: Base, map: Base.Element -> T) {
		self.reducible = reducible
		self.map = map
	}

	// MARK: ReducibleType

	/// Nonrecursive left reduction.
	public func reducer<Result>() -> Reducible<Result, T>.Enumerator -> Reducible<Result, T>.Enumerator {
		let reducer: Reducible<Result, Base.Element>.Enumerator -> Reducible<Result, Base.Element>.Enumerator = reducible.reducer()
		return { recur in
			var reduce: Reducible<Result, Base.Element>.Enumerator!
			return { initial, combine in
				if reduce == nil {
					reduce = reducer { initial, _ in
						recur(initial, combine)
					}
				}
				return reduce(initial, self.transduce(combine))
			}
		}
	}

	// MARK: Private

	private let reducible: Base
	private let map: Base.Element -> T

	private func transduce<Result>(combine: Reducible<Result, T>.Iteratee) -> Reducible<Result, Base.Element>.Iteratee {
		let f = map
		return { into, each in
			combine(into, f(each))
		}
	}
}

public func map<R: ReducibleType, U>(reducible: R, f: R.Element -> U) -> MapReducibleView<R, U> {
	return MapReducibleView(reducible: reducible, map: f)
}
