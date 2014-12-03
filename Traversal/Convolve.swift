//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Constructs the convolution of `r0` and `r1`.
///
/// This is effectively a generalization of `map` to two reducibles.
public func convolve<R0: ReducibleType, R1: ReducibleType>(r0: R0, r1: R1) -> Stream<(R0.Element, R1.Element)> {
	let streams = (Stream(r0), Stream(r1))
	switch (streams.0, streams.1) {
	case let (.Cons(x, xs), .Cons(y, ys)):
		return .cons((x.value, y.value), (convolve(xs.value, ys.value)))
	default:
		return .Nil
	}
}


/// Constructs the convolution of `r0`, `r1`, and `r2`.
///
/// This is effectively a generalization of `map` to three reducibles.
public func convolve<R0: ReducibleType, R1: ReducibleType, R2: ReducibleType>(r0: R0, r1: R1, r2: R2) -> Stream<(R0.Element, R1.Element, R2.Element)> {
	let streams = (Stream(r0), Stream(r1), Stream(r2))
	switch (streams.0, streams.1, streams.2) {
	case let (.Cons(x, xs), .Cons(y, ys), .Cons(z, zs)):
		return .cons((x.value, y.value, z.value), (convolve(xs.value, ys.value, zs.value)))
	default:
		return .Nil
	}
}


// MARK: Imports

import Box
