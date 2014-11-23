//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns a reducer concatenating the results of applying `map` to the elements of `reducible`.
///
/// `map` must return a type conforming to `ReducibleType`.
public func flattenMap<Base: ReducibleType, T: ReducibleType>(reducible: Base, map: Base.Element -> T) -> ReducerOf<Base, T> {
	return ReducerOf(reducible, map)
}

/// Returns a reducer concatenating the results of applying `map` to the elements of `reducible`.
///
/// `map` must return a type conforming to `SequenceType`.
public func flattenMap<Base: ReducibleType, T: SequenceType>(reducible: Base, map: Base.Element -> T) -> ReducerOf<Base, ReducibleOf<T.Generator.Element>> {
	return ReducerOf(reducible) {
		ReducibleOf(sequence: map($0))
	}
}
