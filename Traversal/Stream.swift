//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// An iterable stream.
public enum Stream<T> {
	case Nil
	case Cons(Box<T>, Memo<Stream<T>>)
}


public func first<T>(stream: Stream<T>) -> T? {
	switch stream {
	case .Nil: return nil
	case let .Cons(x, _): return x.value
	}
}

public func dropFirst<T>(stream: Stream<T>) -> Stream<T> {
	switch stream {
	case .Nil: return .Nil
	case let .Cons(_, rest): return rest.value
	}
}


extension Stream {
	public init<R : ReducibleType where R.Element == T>(_ reducible: R) {
		let recur: ((R, Stream, (Stream, T) -> Either<Stream, Stream>) -> Stream) = fix { recur in
			{ reducible, initial, combine in
				switch initial {
				case Nil: return Nil
				case let Cons(x, _): return Cons(x, Memo(reducible.reduceLeft(recur)(reducible, Nil, combine)))
				}
			}
		}

		self = reducible.reduceLeft(recur)(reducible, Nil) { into, each in
			.Right(Box(Cons(Box(each), Memo(Nil))))
		}
	}
}


extension Stream : SequenceType {
	public func generate() -> GeneratorOf<T> {
		var stream = self
		return GeneratorOf {
			switch stream {
			case Nil: return nil
			case let Cons(each, rest):
				stream = rest.value
				return each.value
			}
		}
	}
}
