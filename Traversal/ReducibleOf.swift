//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A reducible over a sequence.
public struct ReducibleOf<T> : ReducibleType {
	// MARK: Lifecycle

	/// Initializes with a sequence.
	public init<S : SequenceType where S.Generator.Element == T>(_ sequence: S) {
		producer = {
			var generator = sequence.generate()
			return { generator.next() }
		}
	}


	// MARK: ReducibleType

	/// Nonrecursive left reduction.
	public func reduceLeft<Result>(recur: (ReducibleOf, Result, (Result, T) -> Either<Result, Result>) -> Result) -> (ReducibleOf, Result, (Result, T) -> Either<Result, Result>) -> Result {
		var producer = self.producer()
		return { collection, initial, combine in
			switch producer() {
			case .None: return initial
			case let .Some(x):
				return map(combine(initial, x)) { recur(self, $0, combine) }
			}
		}
	}


	// MARK: Private

	/// The function which produces the functions which are reduced over.
	///
	/// This indirection is required because GeneratorType is consumed by next(), requiring us to acquire a new generator for each reduction.
	private let producer: () -> () -> T?
}
