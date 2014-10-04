//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A collection which can be left-reduced nonrecursively.
public protocol ReducibleType {
	/// The type of the collection’s elements.
	typealias Element

	/// A nonrecursive left reduce.
	///
	/// Instead of calling itself recursively as a typical left-reduce might do, the implementation calls out via the `recur` parameter instead. This allows the operator to be used for both enumeration (via a fixpoint) and iteration.
	///
	/// This is written in partially applied style to simplify the construction of enumerators.
	func reduceLeft<Result>(recur: (Self, Result, (Result, Element) -> Result) -> Result) -> (Self, Result, (Result, Element) -> Result) -> Result
}
