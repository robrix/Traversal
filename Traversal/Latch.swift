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

	public func reduceLeft<Result>(recur: Reducible<Result, T>.Enumerator) -> Reducible<Result, T>.Enumerator {
		return { initial, combine in combine(initial, self.value).either(id, id) }
	}

	// MARK: Observation

	public mutating func connect(observer: () -> ()) {
		observers.append(observer)
	}

	private var observers: [() -> ()] = []
}
