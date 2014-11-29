//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns a reducer mapping the elements of `reducible` with `f`.
public func map<Base: ReducibleType, T>(reducible: Base, f: Base.Element -> T) -> ReducerOf<Base, Stream<T>> {
	return flattenMap(reducible) {
		.unit(f($0))
	}
}
