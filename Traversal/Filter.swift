//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Box

public struct FilterReducibleView<Base: ReducibleType>: ReducibleType {
	// MARK: ReducibleType

	public func reducer<Result>() -> Reducible<Result, Base.Element>.Enumerator -> Reducible<Result, Base.Element>.Enumerator {
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

	/// Initializes with a reducible and a predicate function.
	private init(reducible: Base, predicate: Base.Element -> Bool) {
		self.reducible = reducible
		self.predicate = predicate
	}

	private let reducible: Base
	private let predicate: Base.Element -> Bool

	private func transduce<Result>(combine: Reducible<Result, Base.Element>.Iteratee) -> Reducible<Result, Base.Element>.Iteratee {
		let f = predicate
		return { into, each in
			f(each) ? combine(into, each) : .Right(Box(into))
		}
	}
}

public func filter<R: ReducibleType>(reducible: R, predicate: R.Element -> Bool) -> FilterReducibleView<R> {
	return FilterReducibleView(reducible: reducible, predicate: predicate)
}
