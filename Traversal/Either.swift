//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A type representing an alternative of one of two types.
///
/// By convention, and where applicable, `Left` is used to indicate failure, while `Right` is used to indicate success. (Mnemonic: “right” is a synonym for “correct.”)
///
/// Otherwise, it is implied that `Left` and `Right` are effectively unordered alternatives of equal standing.
public enum Either<T, U>: Printable {
	case Left(Box<T>)
	case Right(Box<U>)


	// MARK: API

	/// Returns a new `Either` by returning `Left` or applying `f` to the value of `Right`.
	func map<V>(f: U -> V) -> Either<T, V> {
		switch self {
		case let .Left(x):
			return .Left(x)
		case let .Right(x):
			return .Right(Box(f(x.value)))
		}
	}

	/// Returns the result of applying `f` to the value of `Left`, or `g` to the value of `Right`.
	func either<V>(f: T -> V, g: U -> V) -> V {
		switch self {
		case let .Left(x):
			return f(x.value)
		case let .Right(x):
			return g(x.value)
		}
	}


	// MARK: Printable

	public var description: String {
		return either({ ".Left(\($0))"}, { ".Right(\($0))" })
	}
}


// MARK: Imports

import Box
