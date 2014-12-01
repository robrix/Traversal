//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns a reducer mapping the elements of `reducible` with `f`.
public func map<Base: ReducibleType, T>(reducible: Base, f: Base.Element -> T) -> Stream<T> {
	return flattenMap(reducible) {
		Stream.unit(f($0))
	}
}
