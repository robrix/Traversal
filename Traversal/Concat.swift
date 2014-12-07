//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns a reducer concatenating the `ReducibleType` elements of `reducible`.
public func concat<R: ReducibleType where R.Element: ReducibleType>(reducible: R) -> ReducerOf<R.Element.Element> {
	return flattenMap(reducible, id)
}


// MARK: Infix concatenation.

infix operator ++ {
	associativity right
	precedence 145
}

/// Returns a reducer concatenating the elements of `lhs` and `rhs`.
public func ++ <R1: ReducibleType, R2: ReducibleType where R1.Element == R2.Element> (lhs: R1, rhs: R2) -> Stream<R1.Element> {
	return Stream(lhs).uncons().map { x, xs in
		.cons(x, (xs.value ++ rhs))
	} ?? Stream(rhs)
}


// MARK: Imports

import Prelude
