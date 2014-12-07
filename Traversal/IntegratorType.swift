//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Extends `collection` with the elements of a `reducible`.
public func += <E: ExtensibleCollectionType, R: ReducibleType where R.Element == E.Generator.Element> (inout left: E, right: R) {
	reduce(right, ()) {
		left.append($1)
	}
}

public func + <E: ExtensibleCollectionType, R: ReducibleType where R.Element == E.Generator.Element> (left: E, right: R) -> E {
	return reduce(right, left) { $0 + [$1] }
}
