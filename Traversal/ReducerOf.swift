//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A reducible over other reducibles.
///
/// This is a meta-reducer used to implement `flattenMap`, `map`, `filter`, and `concat`.
public struct ReducerOf<Base: ReducibleType, T: ReducibleType>: ReducibleType, Printable {
	// MARK: Lifecycle

	/// Initializes with a base `reducible` and a `map` from the elements of `reducible` to some inhabitant of `ReducibleType`.
	public init(_ reducible: Base, _ map: Base.Element -> T) {
		self.reducible = reducible
		self.map = map
	}


	// MARK: ReducibleType

	public func reducer<Result>() -> Reducible<ReducerOf, Result, T.Element>.Enumerator -> Reducible<ReducerOf, Result, T.Element>.Enumerator {
		return { recur in
			{ collection, initial, combine in
				(collection.reducible.reducer()) { reducible, initial, _ in
					recur(ReducerOf(reducible, collection.map), initial, combine)
				} (collection.reducible, initial) {
					.right(Traversal.reduce(collection.map($1), $0, combine))
				}
			}
		}
	}


	// MARK: Printable

	public var description: String {
		return "ReducerOf(\(reducible))"
	}


	// MARK: Private

	private let reducible: Base
	private let map: Base.Element -> T
}


infix operator ++ {
	associativity right
	precedence 145
}

public struct Reducer<T>: ReducibleType {
	// MARK: Lifecycle

	public init<Base: ReducibleType, Mapped: ReducibleType where Mapped.Element == T>(_ reducible: Base, _ map: Base.Element -> Mapped) {
		self.init(Stream(reducible).map(map >>> Stream.with))
	}


	// MARK: ReducibleType

	public func reducer<Result>() -> Reducible<Reducer, Result, T>.Enumerator -> Reducible<Reducer, Result, T>.Enumerator {
		return { recur in
			{ collection, initial, combine in
				collection.stream.uncons().map { inner, outer in
					(inner.reducer()) { inner, initial, combine in
						recur(Reducer(Stream.unit(inner) ++ outer.value), initial, combine)
					} (inner, initial, combine)
				} ?? initial
			}
		}
	}


	// MARK: Private

	private init(_ stream: Stream<Stream<T>>) {
		self.stream = stream
	}

	private let stream: Stream<Stream<T>>
}


// MARK: Imports

import Memo
import Prelude
