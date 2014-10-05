//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Identity; returns its argument.
func id<T>(x: T) -> T {
	return x
}

/// Returns a fixpoint of f(), i.e. a value x for which f(x) returns x.
///
/// This is used to make recursive reduce() from nonrecursive reduceLeft().
public func fix<A, B>(f : (A -> B) -> A -> B) -> A -> B {
	return { x in f(fix(f))(x) }
}
