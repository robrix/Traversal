//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Signal<T>: ObservableType {
	public init<R: ReducibleType>(_ reducible: R, _ map: R.Element -> T) {
		var input = Stream(reducible)
		source = SourceOf {
			map(first(input)!)
		}
	}

	// MARK: Reduction

	public func reducer<Result>() -> Reducible<Result, T>.Enumerator -> Reducible<Result, T>.Enumerator {
		return source.reducer()
	}

	// MARK: Observation

	public mutating func connect(observer: () -> ()) {
		source.connect(observer)
	}

	// MARK: Implementation details

	private var source: SourceOf<T>
}
