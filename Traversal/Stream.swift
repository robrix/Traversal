//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Box

/// An iterable stream.
public enum Stream<T> {
	case Cons(Box<T>, Memo<Stream<T>>)
	case Nil
}


/// Returns the first element of `stream`, or nil if `stream` is `Nil`.
public func first<T>(stream: Stream<T>) -> T? {
	switch stream {
	case .Nil: return nil
	case let .Cons(x, _): return x.value
	}
}

/// Drops the first element of `stream`.
public func dropFirst<T>(stream: Stream<T>) -> Stream<T> {
	switch stream {
	case .Nil:
		return .Nil
	case let .Cons(_, rest):
		return rest.value
	}
}


extension Stream {
	/// Initializes with a ReducibleType.
	public init<R : ReducibleType where R.Element == T>(_ reducible: R) {
		let reduce: Reducible<Stream, T>.Enumerator = reducible.reducer()({ initial, _ in initial })
		let combine = fix { combine in
			{ into, each in .Right(Box(Cons(Box(each), Memo(reduce(into, combine))))) }
		}
		self = reduce(Nil, combine)
	}
}


/// Stream conforms to SequenceType.
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

/// Stream conforms to ReducibleType.
extension Stream: ReducibleType {
	public func reducer<Result>() -> Reducible<Result, T>.Enumerator -> Reducible<Result, T>.Enumerator {
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

