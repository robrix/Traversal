//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// An iterable stream.
public enum Stream<T> {
	case Cons(Box<T>, Memo<Stream<T>>)
	case Nil


	// MARK: Lifecycle

	/// Initializes with a ReducibleType.
	public init<R: ReducibleType where R.Element == T>(_ reducible: R) {
		let reduce: Reducible<R, Stream, T>.Enumerator = (reducible.reducer()) { _, initial, _ in initial }
		self = reduce(reducible, Nil, fix { combine in
			{ .right(.cons($1, Memo(reduce(reducible, $0, combine)))) }
		})
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
			{ generate().map { self.cons($0, Memo(recur())) } ?? Nil }
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
