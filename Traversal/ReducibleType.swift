//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Box

/// A collection which can be left-reduced nonrecursively.
public protocol ReducibleType {
	/// The type of the collection’s elements.
	typealias Element

	/// A nonrecursive left reduce.
	///
	/// Instead of calling itself recursively as a typical left-reduce might do, the implementation calls out via the `recur` parameter instead. This allows the operator to be used for both enumeration (via a fixpoint) and iteration.
	///
	/// This is written in partially applied style to simplify the construction of enumerators.
	///
	/// The combine function returns Either in order to enable early termination; returning Either.Left(x) indicates that reduction should conclude immediately with x, whereas Either.Right(y) indicates that reduction should continue with y.
	func reduceLeft<Result>(recur: (Self, Result, (Result, Element) -> Either<Result, Result>) -> Result) -> (Self, Result, (Result, Element) -> Either<Result, Result>) -> Result
}


/// Left-reduction of a reducible.
public func reduce<R : ReducibleType, Result>(collection: R, initial: Result, combine: (Result, R.Element) -> Either<Result, Result>) -> Result {
	return fix { recur in
		{ collection, initial, combine in
			collection.reduceLeft(recur)(collection, initial, combine)
		}
	} (collection, initial, combine)
}


/// Left-reduction of a reducible.
///
/// Unlike the version above, this version takes a function returning Result instead of Either<Result, Result>. As such, it may be more convenient for cases not needing early termination.
public func reduce<R : ReducibleType, Result>(collection: R, initial: Result, combine: (Result, R.Element) -> Result) -> Result {
	return reduce(collection, initial) { .Right(Box(combine($0, $1))) }
}
