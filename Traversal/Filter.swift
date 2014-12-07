//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns a reducer filtering out any elements of `reducible` which are not matched by `predicate`.
public func filter<Base: ReducibleType>(reducible: Base, predicate: Base.Element -> Bool) -> ReducerOf<Base.Element> {
	return flattenMap(reducible) {
		predicate($0) ? Stream.unit($0) : nil
	}
}


/// A predicate which accepts all values.
public func acceptAll<T>(x: T) -> Bool { return true }

/// A predicate which rejects all values.
public func rejectAll<T>(x: T) -> Bool { return false }

/// A predicate which accepts only `nil` values.
public func acceptNil<T>(x: T?) -> Bool { return x == nil }

/// A predicate which accepts only non-`nil` values.
public func rejectNil<T>(x: T?) -> Bool { return x != nil }
