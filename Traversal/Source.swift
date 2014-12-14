//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// An observable source of lazily memoized sampled values.
public final class Source<T>: ReducibleType {
	// MARK: Constructors

	/// Constructs a source using a `sampler` function.
	public init(_ sampler: () -> T) {
		self.sampler = sampler
	}


	// MARK: API

	/// Invalidates the source, causing it to push a new lazily memoized sample to each of its observers.
	public func invalidate() {
		let sample = self.sample()
		for observer in observers {
			observer(sample)
		}
	}


	// MARK: ReducibleType

	public func reducer<Result>() -> Reducible<Source, Result, Memo<T>>.Enumerator -> Reducible<Source, Result, Memo<T>>.Enumerator {
		return { recur in
			// add an observer
			{ collection, initial, combine in
				self.observers.append(observer(initial, combine))
				return initial
			}
		}
	}


	// MARK: Private

	/// Returns a lazily memoized sample taken with `sampler`.
	private func sample() -> Memo<T> {
		let sampler = self.sampler
		return Memo(sampler())
	}

	/// A function providing the values reduced over by the receiver.
	private var sampler: () -> T

	/// Observers to notify when invalidated. Any or all of these may ignore the observation by simply not evaluating the `Memo`.
	private var observers: [Memo<T> -> ()] = []
}


/// Returns an observer of a source’s elements given an `initial` value and a `combine` function.
private func observer<Result, Element>(initial: Result, combine: (Result, Element) -> Either<Result, Result>) -> Element -> () {
	return { each in
		const(()) <| combine(initial, each)
	}
}


// MARK: Import

import Either
import Memo
import Prelude
