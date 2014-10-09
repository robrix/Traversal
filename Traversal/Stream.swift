//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// An iterable stream.
public enum Stream<T> {
	case Nil
	case Cons(Box<T>, @autoclosure () -> Stream<T>)
}

