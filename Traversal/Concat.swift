//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns a reducer concatenating the elements of `reducible`.
public func concat<Base: ReducibleType where Base.Element: SequenceType>(reducible: Base) -> FlattenMapReducibleView<Base, ReducibleOf<Base.Element.Generator.Element>> {
	return flattenMap(reducible, id)
}
