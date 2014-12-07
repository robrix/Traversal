//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns a reducer interleaving the elements of `reducible` with `separator`.
public func join<R: ReducibleType>(separator: R.Element, reducible: R) -> ReducerOf<R.Element> {
	var firstIteration = true
	let x = flattenMap(reducible) { each -> Stream<R.Element> in
		let stream: Stream<R.Element> = firstIteration ? Stream.unit(each) : Stream([separator, each])
		firstIteration = false
		return stream
	}
	return x
}
