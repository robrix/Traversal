//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns a reducer concatenating the results of applying `map` to the elements of `reducible`.
///
/// `map` must return a type conforming to `ReducibleType`.
public func flattenMap<Base: ReducibleType, T: ReducibleType>(reducible: Base, map: Base.Element -> T) -> ReducerOf<Base, T> {
	return ReducerOf(reducible, map)
}
