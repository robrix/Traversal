//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct SourceOf<T>: ObservableType {
	public init(_ sample: () -> T) {
		self.sample = sample
	}

	// MARK: ReducibleType

	public func reducer<Result>() -> Reducible<Result, T>.Enumerator -> Reducible<Result, T>.Enumerator {
		return { recur in
			{ initial, combine in combine(initial, self.sample()).either(id, id) }
		}
	}

	// MARK: Observation

	public func invalidate() {
		for observer in observers { observer() }
	}

	public mutating func connect(observer: () -> ()) {
		observers.append(observer)
	}

	// MARK: Implementation details

	private let sample: () -> T
	private var observers: [() -> ()] = []
}
