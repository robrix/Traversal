//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A reducible over a sequence.
public struct ReducibleOf<T> : ReducibleType {
	// MARK: Lifecycle

	/// Initializes with a sequence.
	public init<S : SequenceType where S.Generator.Element == T>(_ sequence: S) {
		self.init({
			var generator = sequence.generate()
			return { generator.next() }
		})
	}


	// MARK: ReducibleType

	/// Nonrecursive left reduction.
	public func reduceLeft<Result>(recur: (ReducibleOf, Result, (Result, T) -> Either<Result, Result>) -> Result) -> (ReducibleOf, Result, (Result, T) -> Either<Result, Result>) -> Result {
		var producer = self.producer()
		return { collection, initial, combine in
			return producer().map { combine(initial, $0).map { recur(ReducibleOf { producer }, $0, combine) }.either(id, id) } ?? initial
		}
	}


	// MARK: Private

	/// Initializes with a function which produces generator functions.
	private init(_ producer: () -> () -> T?) {
		self.producer = producer
	}

	/// The function which produces the functions which are reduced over.
	///
	/// This indirection is required because GeneratorType is consumed by next(), requiring us to acquire a new generator for each reduction.
	private let producer: () -> () -> T?
}
