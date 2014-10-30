//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Identity; returns its argument.
func id<T>(x: T) -> T {
	return x
}

/// Returns a fixpoint of a function f, i.e. a value x for which f(x) returns x.
///
/// This is used to make recursive reduce() from nonrecursive reduceLeft().
public func fix<A, B>(f: (A -> B) -> A -> B) -> A -> B {
	return { x in f(fix(f))(x) }
}

/// Returns a function which accepts & ignores a parameter, always returning `x` instead.
public func const<T, U>(x: U)(T) -> U {
	return x
}
