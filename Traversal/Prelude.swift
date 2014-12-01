//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Identity; returns its argument.
public func id<T>(x: T) -> T {
	return x
}

/// Returns a fixpoint of a function f, i.e. a value x for which f(x) returns x.
///
/// This is used to make recursive reduce() from nonrecursive reduceLeft().
public func fix<A, B>(f: (A -> B) -> A -> B) -> A -> B {
	return { x in f(fix(f))(x) }
}


infix operator .. { associativity right }

/// Unary function composition.
public func .. <T, U, V>(f: U -> V, g: T -> U) -> T -> V {
	return { f(g($0)) }
}


/// Unary/binary function composition (curried).
public func .. <T, U, V, W>(f: V -> W, g: T -> U -> V) -> (T, U) -> W {
	return uncurry { f .. g($0) }
}

/// Unary/binary function composition (uncurried).
public func .. <T, U, V, W>(f: V -> W, g: (T, U) -> V) -> (T, U) -> W {
	return f .. curry(g)
}

/// Binary/unary function composition (curried).
public func .. <T, U, V, W>(f: U -> V -> W, g: T -> U) -> (T, V) -> W {
	return uncurry(f .. g)
}

/// Binary/unary function composition (uncurried).
public func .. <T, U, V, W>(f: (U, V) -> W, g: T -> U) -> (T, V) -> W {
	return curry(f) .. g
}


/// Binary/binary function composition (curried, curried).
public func .. <T, U, V, W, X>(f: V -> W -> X, g: T -> U -> V) -> (T, U, W) -> X {
	return uncurry { f .. g($0) }
}

/// Binary/binary function composition (curried, uncurried).
public func .. <T, U, V, W, X>(f: V -> W -> X, g: (T, U) -> V) -> (T, U, W) -> X {
	return f .. curry(g)
}

/// Binary/binary function composition (uncurried, curried).
public func .. <T, U, V, W, X>(f: (V, W) -> X, g: T -> U -> V) -> (T, U, W) -> X {
	return curry(f) .. g
}

/// Binary/binary function composition (uncurried, uncurried).
public func .. <T, U, V, W, X>(f: (V, W) -> X, g: (T, U) -> V) -> (T, U, W) -> X {
	return curry(f) .. curry(g)
}


/// Binary currying.
public func curry<T, U, V>(f: (T, U) -> V) -> T -> U -> V {
	return { x in { y in f(x, y) } }
}

/// Ternary currying.
public func curry<T, U, V, W>(f: (T, U, V) -> W) -> T -> U -> V -> W {
	return { x in curry { y, z in f(x, y, z) } }
}


/// Binary uncurrying.
public func uncurry<T, U, V>(f: T -> U -> V) -> (T, U) -> V {
	return { x, y in
		f(x)(y)
	}
}

/// Ternary uncurrying.
public func uncurry<T, U, V, W>(f: T -> U -> V -> W) -> (T, U, V) -> W {
	return { x, y, z in
		f(x)(y)(z)
	}
}
