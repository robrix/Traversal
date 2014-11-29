//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns a reducer interleaving the elements of `reducible` with `separator`.
public func join<R: ReducibleType>(separator: R.Element, reducible: R) -> ReducerOf<R, Stream<R.Element>> {
	var firstIteration = true
	return flattenMap(reducible) {
		let sequence = SequenceOf(firstIteration ? [$0] : [separator, $0])
		firstIteration = false
		return Stream(sequence)
	}
}
