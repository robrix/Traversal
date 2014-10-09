//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A box to put a replaceable thing in.
public final class MutableBox<T>: BoxType {
	public var value: T
	public init(_ v: T) {
		value = v
	}
}
