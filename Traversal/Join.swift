//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns a reducer interleaving the elements of `reducible` with `separator`.
public func join<R: ReducibleType>(separator: R.Element, reducible: R) -> ReducerOf<R, ReducibleOf<R.Element>> {
	var iteration = 0
	return flattenMap(reducible) {
		SequenceOf(iteration++ == 0 ? [$0] : [separator, $0])
	}
}
