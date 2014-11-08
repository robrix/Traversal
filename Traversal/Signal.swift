//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Signal<T>: ObservableType {
	// MARK: Lifecycle

	public init<O: ObservableType>(inout _ observable: O, _ map: O.Element -> T) {
		var input = Stream(observable)
		let s = SourceOf { map(first(input)!) }
		observable.connect { s.invalidate() }
		source = s
	}

	public init<R: ReducibleType>(_ reducible: R, _ map: R.Element -> T) {
		var input = Stream(reducible)
		source = SourceOf {
			map(first(input)!)
		}
	}


	// MARK: ReducibleType

	public func reducer<Result>() -> Reducible<Result, T>.Enumerator -> Reducible<Result, T>.Enumerator {
		return source.reducer()
	}


	// MARK: ObservableType

	public mutating func connect(observer: () -> ()) {
		source.connect(observer)
	}


	// MARK: Private

	private var source: SourceOf<T>
}
