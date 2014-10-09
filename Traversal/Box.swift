//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A box to put a thing in.
public final class Box<T>: BoxType {
	public let value: T
	public init(_ v: T) {
		value = v
	}
}
