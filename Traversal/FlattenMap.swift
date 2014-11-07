//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Box

public struct FlattenMapReducibleView<Base: ReducibleType, T: ReducibleType>: ReducibleType {
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

public func flattenMap<Base: ReducibleType, T: ReducibleType>(reducible: Base, map: Base.Element -> T) -> FlattenMapReducibleView<Base, T> {
	return FlattenMapReducibleView(reducible: reducible, map: map)
}

public func flattenMap<Base: ReducibleType, T: SequenceType>(reducible: Base, map: Base.Element -> T) -> FlattenMapReducibleView<Base, ReducibleOf<T.Generator.Element>> {
	return FlattenMapReducibleView(reducible: reducible) {
		ReducibleOf(sequence: map($0))
	}
}
