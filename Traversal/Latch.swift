//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Latch<T>: ReducibleType, ObservableType {
	public var value: T {
		didSet {
			for observer in observers { observer() }
		}
	}

	public init(value: T) {
		self.value = value
	}

	public func reduceLeft<Result>(recur: Reducible<Latch, Result, T>.Enumerator) -> Reducible<Latch, Result, T>.Enumerator {
		return { latch, initial, combine in combine(initial, latch.value).either(id, id) }
	}

	// MARK: Observation

	public mutating func connect(observer: () -> ()) {
		observers.append(observer)
	}

	private var observers: [() -> ()] = []
}
