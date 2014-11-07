//  Copyright (c) 2014 Rob Rix. All rights reserved.

public func flattenMap<Base: ReducibleType, T: ReducibleType>(reducible: Base, map: Base.Element -> T) -> ReducerOf<Base, T> {
	return ReducerOf(reducible: reducible, map: map)
}

public func flattenMap<Base: ReducibleType, T: SequenceType>(reducible: Base, map: Base.Element -> T) -> ReducerOf<Base, ReducibleOf<T.Generator.Element>> {
	return ReducerOf(reducible: reducible) {
		ReducibleOf(sequence: map($0))
	}
}
