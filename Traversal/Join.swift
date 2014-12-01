//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns a reducer interleaving the elements of `reducible` with `separator`.
public func join<R: ReducibleType>(separator: R.Element, reducible: R) -> Stream<R.Element> {
	return Stream(reducible).destructure().map {
		.cons($0, Memo($1.value.flattenMap { Stream([separator, $0]) }))
	} ?? .Nil
}
