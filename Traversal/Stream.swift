//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// An iterable stream.
public enum Stream<T> {
	case Nil
	case Cons(Box<T>, @autoclosure () -> Stream<T>)
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
	case let .Cons(_, rest): return rest()
	}
}

