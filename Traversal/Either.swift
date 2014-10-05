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

func map<T, U, V>(either: Either<T, U>, f: U -> V) -> Either<T, V> {
	switch either {
	case let .Left(x): return .Left(x)
	case let .Right(x): return .Right(Box(f(x.value)))
	}
}

func id<T>(x: T) -> T {
	return x
}
