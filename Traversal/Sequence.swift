//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Produces a `SequenceOf` which iterates the elements of `reducible`.
public func sequence<R: ReducibleType>(reducible: R) -> SequenceOf<R.Element> {
	let stream = Stream(reducible)
	return SequenceOf({ stream.generate() })
}
