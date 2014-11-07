//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Box

/// A reducible over other reducibles.
///
/// This is a meta-reducer used to implement `flattenMap`, `map`, `filter`, and `concat`.
public struct ReducerOf<Base: ReducibleType, T: ReducibleType>: ReducibleType {
	// MARK: Lifecycle

	public init(reducible: Base, map: Base.Element -> T) {
		self.reducible = reducible
		self.map = map
	}

	// MARK: ReducibleType

	public func reducer<Result>() -> Reducible<Result, T.Element>.Enumerator -> Reducible<Result, T.Element>.Enumerator {
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

	private func transduce<Result>(combine: Reducible<Result, T.Element>.Iteratee) -> Reducible<Result, Base.Element>.Iteratee {
		let f = map
		return { into, each in
			.Right(Box(reduce(f(each), into, combine)))
		}
	}
}
