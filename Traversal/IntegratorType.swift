//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Appends `collection` with the elements of a `reducible`.
public func += <E: ExtensibleCollectionType, R: ReducibleType where R.Element == E.Generator.Element> (inout left: E, right: R) {
	reduce(right, ()) {
		left.append($1)
	}
}
