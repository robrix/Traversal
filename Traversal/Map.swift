//  Copyright (c) 2014 Rob Rix. All rights reserved.

public func map<Base: ReducibleType, T>(reducible: Base, f: Base.Element -> T) -> FlattenMapReducibleView<Base, ReducibleOf<T>> {
	return flattenMap(reducible) {
		GeneratorOfOne(f($0))
	}
}
