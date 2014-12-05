//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// An iterable stream.
public enum Stream<T> {
	case Cons(Box<T>, Memo<Stream<T>>)
	case Nil


	// MARK: Lifecycle

	/// Initializes with a ReducibleType.
	public init<R: ReducibleType where R.Element == T>(_ reducible: R) {
		let reducer: Reducible<R, Stream, T>.Enumerator -> Reducible<R, Stream, T>.Enumerator = reducible.reducer()
		let reduce: Reducible<R, Stream, T>.Enumerator = fix { recur in
			reducer { reducible, initial, combine in
				initial.first.map { .cons($0, recur(reducible, Nil, combine)) } ?? Nil
			}
		}
		self = reduce(reducible, Nil) {
			.right(.unit($1))
		}
	}


	/// Initializes with a generating function.
	public init(_ f: () -> T?) {
		self = Stream.construct(f)()
	}

	/// Initializes with a `SequenceType`.
	public init<S: SequenceType where S.Generator.Element == T>(_ sequence: S) {
		var generator = sequence.generate()
		self.init({ generator.next() })
	}


	/// Maps a generator of `T?` into a generator of `Stream`.
	public static func construct(generate: () -> T?) -> () -> Stream<T> {
		return fix { recur in
			{ generate().map { self.cons($0, recur()) } ?? Nil }
		}
	}

	/// Constructs a `Stream` from `first` and its `@autoclosure`’d continuation.
	public static func cons(first: T, _ rest: @autoclosure () -> Stream) -> Stream {
		return Cons(Box(first), Memo(unevaluated: rest))
	}

	/// Constructs a `Stream` from `first` and its `Memo`ized continuation.
	public static func cons(first: T, _ rest: Memo<Stream>) -> Stream {
		return Cons(Box(first), rest)
	}

	/// Constructs a unary `Stream` of `x`.
	public static func unit(x: T) -> Stream {
		return Cons(Box(x), Memo(.Nil))
	}

	/// Constructs a `Stream` of `reducible`. Unlike the corresponding `init`, this is suitable for function composition.
	public static func with<R: ReducibleType where R.Element == T>(reducible: R) -> Stream {
		return Stream(reducible)
	}


	// MARK: Properties

	public var first: T? {
		return destructure()?.0
	}

	public var rest: Stream {
		return destructure()?.1.value ?? Nil
	}


	public func destructure() -> (T, Memo<Stream>)? {
		switch self {
		case let Cons(x, rest):
			return (x.value, rest)
		case Nil:
			return nil
		}
	}


	// MARK: Combinators

	/// Returns a `Stream` of the first `n` elements of the receiver.
	///
	/// If `n` <= 0, returns the empty `Stream`.
	public func take(n: Int) -> Stream {
		if n <= 0 { return Nil }

		return destructure().map { .cons($0, $1.value.take(n - 1)) } ?? Nil
	}

	/// Returns a `Stream` without the first `n` elements of `stream`.
	///
	/// If `n` <= 0, returns the receiver.
	///
	/// If `n` <= the length of the receiver, returns the empty `Stream`.
	public func drop(n: Int) -> Stream {
		if n <= 0 { return self }

		return rest.drop(n - 1)
	}


	/// Returns a `Stream` produced by mapping the elements of the receiver with `f`.
	public func map<U>(f: T -> U) -> Stream<U> {
		return destructure().map { .cons(f($0), $1.value.map(f)) } ?? .Nil
	}


	/// Folds the receiver starting from a given `seed` using the left-associative function `combine`.
	public func foldLeft<Result>(seed: Result, _ combine: (Result, T) -> Result) -> Result {
		return destructure().map { $1.value.foldLeft(combine(seed, $0), combine) } ?? seed
	}

	/// Folds the receiver ending with a given `seed` using the right-associative function `combine`.
	public func foldRight<Result>(seed: Result, _ combine: (T, Result) -> Result) -> Result {
		return destructure().map { combine($0, $1.value.foldRight(seed, combine)) } ?? seed
	}


	/// Unfolds a new `Stream` starting from the initial state `state` and producing pairs of new states and values with `unspool`.
	///
	/// This is dual to `foldRight`. Where `foldRight` takes a right-associative combine function which takes the current value and the current accumulator and returns the next accumulator, `unfold` takes the current state and returns the current value and the next state.
	public static func unfold<State>(state: State, unspool: State -> (T, State)?) -> Stream {
		return unspool(state).map { value, next in self.cons(value, self.unfold(next, unspool)) } ?? Nil
	}


	/// Produces a `Stream` by mapping the elements of the receiver into reducibles and concatenating their elements.
	public func flattenMap<R: ReducibleType>(f: T -> R) -> Stream<R.Element> {
		return foldRight(.Nil, f >>> Stream<R.Element>.with >>> (++))
	}
}


// MARK: API

/// Returns the first element of `stream`, or `nil` if `stream` is `Nil`.
public func first<T>(stream: Stream<T>) -> T? {
	return stream.first
}

/// Drops the first element of `stream`.
public func dropFirst<T>(stream: Stream<T>) -> Stream<T> {
	return stream.rest
}


infix operator ++ {
	associativity right
	precedence 145
}

/// Produces the concatenation of `left` and `right`.
public func ++ <T> (left: Stream<T>, right: Stream<T>) -> Stream<T> {
	return left.destructure().map {
		.cons($0, Memo($1.value ++ right))
	} ?? right
}


// MARK: SequenceType conformance.

extension Stream: SequenceType {
	public func generate() -> GeneratorOf<T> {
		var stream = self
		return GeneratorOf {
			let first = stream.first
			stream = stream.rest
			return first
		}
	}
}


// MARK: ReducibleType conformance.

extension Stream: ReducibleType {
	public func reducer<Result>() -> Reducible<Stream, Result, T>.Enumerator -> Reducible<Stream, Result, T>.Enumerator {
		return { recur in
			{ stream, initial, combine in
				stream.first.map {
					combine(initial, $0).either(id, { recur(stream.rest, $0, combine) })
				} ?? initial
			}
		}
	}
}


// MARK: Printable conformance.

extension Stream: Printable {
	public var description: String {
		let internalDescription: Stream -> [String] = fix { internalDescription in {
				switch $0 {
				case let Cons(x, rest):
					return [toString(x.value)] + internalDescription(rest.value)
				default:
					return []
				}
			}
		}
		return "(" + join(" ", internalDescription(self)) + ")"
	}
}


// MARK: Equality.

/// Equality of `Stream`s of `Equatable` types.
///
/// We cannot declare that `Stream<T: Equatable>` conforms to `Equatable`, so this is defined ad hoc.
public func == <T: Equatable> (lhs: Stream<T>, rhs: Stream<T>) -> Bool {
	switch (lhs, rhs) {
	case let (.Cons(x, xs), .Cons(y, ys)) where x == y:
		return xs.value == ys.value
	case (.Nil, .Nil):
		return true
	default:
		return false
	}
}


/// Inequality of `Stream`s of `Equatable` types.
///
/// We cannot declare that `Stream<T: Equatable>` conforms to `Equatable`, so this is defined ad hoc.
public func != <T: Equatable> (lhs: Stream<T>, rhs: Stream<T>) -> Bool {
	switch (lhs, rhs) {
	case let (.Cons(x, xs), .Cons(y, ys)) where x == y:
		return xs.value != ys.value
	case (.Nil, .Nil):
		return false
	default:
		return true
	}
}


// MARK: Imports

import Box
import Memo
import Prelude
