//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class StreamTests: XCTestCase {
	func testStreams() {
		let sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9]
		let reducible = ReducibleOf(sequence)
		let stream = Stream(reducible)

		XCTAssertEqual(first(stream)!, 1)
		XCTAssertEqual(first(stream)!, 1)
		XCTAssertEqual(first(dropFirst(stream))!, 2)
		XCTAssertEqual(first(dropFirst(stream))!, 2)
	}
}
