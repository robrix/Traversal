//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct SourceOf<T>: ObservableType {
	public init(_ sample: () -> T) {
		self.sample = sample
	}

	// MARK: ReducibleType

	public func reduceLeft<Result>(recur: Reducible<SourceOf, Result, T>.Enumerator) -> Reducible<SourceOf, Result, T>.Enumerator {
		return { source, initial, combine in combine(initial, source.sample()).either(id, id) }
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
