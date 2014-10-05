//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Either<T, U> {
	case Left(Box<T>)
	case Right(Box<U>)

	func either<V>(f: T -> V, g: U -> V) -> V {
		switch self {
		case let .Left(x): return f(x.value)
		case let .Right(x): return g(x.value)
		}
	}
}

func map<T>(either: Either<T, T>, f: T -> T) -> T {
	switch either {
	case let .Left(x): return x.value
	case let .Right(x): return f(x.value)
	}
}
