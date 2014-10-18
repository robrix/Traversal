//  Copyright (c) 2014 Rob Rix. All rights reserved.

struct Latch<T>: SinkType {
	var value: T

	mutating func put(x: T) {
		value = x
	}
}
