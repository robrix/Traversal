//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns a reducer concatenating the `ReducibleType` elements of `reducible`.
public func concat<R: ReducibleType where R.Element: ReducibleType>(reducible: R) -> ReducerOf<R, R.Element> {
	return flattenMap(reducible, id)
}

/// Returns a reducer concatenating the `SequenceType` elements of `reducible`.
public func concat<Base: ReducibleType where Base.Element: SequenceType>(reducible: Base) -> ReducerOf<Base, ReducibleOf<Base.Element.Generator.Element>> {
	return flattenMap(reducible, id)
}


// MARK: Infix concatenation.

infix operator ++ {
	associativity right
	precedence 145
}

/// Returns a reducer concatenating the elements of `lhs` and `rhs`.
public func ++ <R1: ReducibleType, R2: ReducibleType where R1.Element == R2.Element> (lhs: R1, rhs: R2) -> ReducibleOf<R1.Element> {
	var generators = (Stream(lhs).generate(), Stream(rhs).generate())
	return ReducibleOf {
		GeneratorOf {
			generators.0.next() ?? generators.1.next()
		}
	}
}
