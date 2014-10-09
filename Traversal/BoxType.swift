//  Copyright (c) 2014 Rob Rix. All rights reserved.

public protocol BoxType {
	typealias Value
	var value: Value { get }

	init(_: Value)
}