//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// An iterable stream.
public enum Stream<T> {
	case Cons(Box<T>, Memo<Stream<T>>)
	case Nil


	// MARK: Lifecycle

	/// Initializes with a ReducibleType.
	public init<R : ReducibleType where R.Element == T>(_ reducible: R) {
		let reduce: Reducible<Stream, T>.Enumerator = reducible.reducer()({ initial, _ in initial })
		let combine = fix { combine in
			{ into, each in .Right(Box(Cons(Box(each), Memo(reduce(into, combine))))) }
		}
		self = reduce(Nil, combine)
	}
}


// MARK: API

/// Returns the first element of `stream`, or nil if `stream` is `Nil`.
public func first<T>(stream: Stream<T>) -> T? {
	switch stream {
	case let .Cons(x, _):
		return x.value
	case .Nil:
		return nil
	}
}

/// Drops the first element of `stream`.
public func dropFirst<T>(stream: Stream<T>) -> Stream<T> {
	switch stream {
	case let .Cons(_, rest):
		return rest.value
	case .Nil:
		return .Nil
	}
}


// MARK: SequenceType conformance.

extension Stream: SequenceType {
	public func generate() -> GeneratorOf<T> {
		var stream = self
		return GeneratorOf {
			switch stream {
			case let Cons(each, rest):
				stream = rest.value
				return each.value
			case Nil:
				return nil
			}
		}
	}
}


// MARK: ReducibleType conformance.

extension Stream: ReducibleType {
	public func reducer<Result>() -> Reducible<Result, T>.Enumerator -> Reducible<Result, T>.Enumerator {
		// Unlike Oleg’s definitions, we don’t use a monadic type and express the sequential control flow via repeated binds. Therefore, we hide a tiny bit of mutable state in here—a variable which we advance manually. I can live with this for now, because I am a monster.
		var stream = self
		return { recur in
			{ initial, combine in
				first(stream).map {
					stream = dropFirst(stream)
					return combine(initial, $0).either(const(initial)) { recur($0, combine) }
				} ?? initial
			}
		}
	}
}


// MARK: Printable conformance.
extension Stream: Printable {
	public var description: String {
		return "(" + join(" ", internalDescription) + ")"
	}

	private var internalDescription: [String] {
		switch self {
		case let Cons(x, rest):
			return [toString(x.value)] + rest.value.internalDescription
		default:
			return []
		}
	}
}


// MARK: Imports

import Box
