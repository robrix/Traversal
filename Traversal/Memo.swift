//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Deferred, memoized evaluation.
public struct Memo<T> {
	// MARK: Lifecycle

	public init(_ unevaluated: @autoclosure () -> T) {
		state = MutableBox(.Unevaluated(unevaluated))
	}

	public init(evaluated: T) {
		self.init(state: .Evaluated(Box(evaluated)))
	}


	// MARK: Properties

	public var value: T {
		switch state.value {
		case let .Evaluated(x): return x.value
		case let .Unevaluated(f):
			let value = f()
			state.value = .Evaluated(Box(value))
			return value
		}
	}


	// MARK: API

	func map<U>(f: T -> U) -> Memo<U> {
		return Memo<U>(f(value))
	}


	// MARK: Private

	private init(state: MemoState<T>) {
		self.init(state: MutableBox(state))
	}
	private init(state: MutableBox<MemoState<T>>) {
		self.state = state
	}

	private let state: MutableBox<MemoState<T>>
}


// MARK: Private

/// Private state for memoization.
private enum MemoState<T> {
	case Evaluated(Box<T>)
	case Unevaluated(@autoclosure () -> T)
}


// MARK: Imports

import Box
