//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct SourceOf<T>: ObservableType {
	// MARK: Lifecycle

	public init(_ sampler: () -> T) {
		self.sampler = sampler
	}


	// MARK: ReducibleType

	public func reducer<Result>() -> Reducible<Result, T>.Enumerator -> Reducible<Result, T>.Enumerator {
		return { recur in
			{ initial, combine in combine(initial, self.sampler()).either(id, id) }
		}
	}


	// MARK: ObservableType

	public func invalidate() {
		for observer in observers { observer() }
	}

	public mutating func connect(observer: () -> ()) {
		observers.append(observer)
	}


	// MARK: Private

	private let sampler: () -> T
	private var observers: [() -> ()] = []
}
