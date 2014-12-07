//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A reducible over other reducibles.
///
/// This is a meta-reducer used to implement `flattenMap`, `map`, `filter`, and `concat`.
public struct ReducerOf<T>: ReducibleType {
	// MARK: Lifecycle

	public init<Base: ReducibleType, Mapped: ReducibleType where Mapped.Element == T>(_ reducible: Base, _ map: Base.Element -> Mapped) {
		self.init(Stream(reducible).map(map >>> Stream.with))
	}


	// MARK: ReducibleType

	public func reducer<Result>() -> Reducible<ReducerOf, Result, T>.Enumerator -> Reducible<ReducerOf, Result, T>.Enumerator {
		return { recur in
			fix { next in
				{ collection, initial, combine in
					collection.stream.uncons().map { inner, outer in
						inner.uncons().map { _ in
							(inner.reducer()) { inner, initial, combine in
								recur(ReducerOf(Stream.unit(inner) ++ outer.value), initial, combine)
							} (inner, initial, combine)
						} ?? next(ReducerOf(outer.value), initial, combine)
					} ?? initial
				}
			}
		}
	}


	// MARK: Private

	private init(_ stream: Stream<Stream<T>>) {
		self.stream = stream
	}

	private let stream: Stream<Stream<T>>
}


// MARK: Operators

infix operator ++ {
	associativity right
	precedence 145
}


// MARK: Imports

import Memo
import Prelude
