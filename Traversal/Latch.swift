//  Copyright (c) 2014 Rob Rix. All rights reserved.

struct Latch<T>: SinkType, ReducibleType {
	var value: T

	mutating func put(x: T) {
		value = x
	}

	func reduceLeft<Result>(recur: Reducible<Latch, Result, T>.Enumerator) -> Reducible<Latch, Result, T>.Enumerator {
		return { latch, initial, combine in combine(initial, latch.value).either(id, id) }
	}
}
