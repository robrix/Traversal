//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Latch<T>: ReducibleType {
	public var value: T

	public func reduceLeft<Result>(recur: Reducible<Latch, Result, T>.Enumerator) -> Reducible<Latch, Result, T>.Enumerator {
		return { latch, initial, combine in recur(latch, combine(initial, latch.value).either(id, id), combine) }
	}
}
