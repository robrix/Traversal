//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Either<T, U> {
	case Left(Box<T>)
	case Right(Box<U>)
}
