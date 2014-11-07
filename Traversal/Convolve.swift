//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Constructs the convolution of `r0` and `r1`.
///
/// This is effectiely a generalization of `map` to two reducibles.
func convolve<R0: ReducibleType, R1: ReducibleType>(r0: R0, r1: R1) -> Stream<(R0.Element, R1.Element)> {
	let streams = (Stream(r0), Stream(r1))
	return Stream {
		switch (streams.0, streams.1) {
		case let (.Cons(x, _), .Cons(y, _)):
			return (x.value, y.value)
		default:
			return nil
		}
	}
}


// MARK: Imports

import Box
