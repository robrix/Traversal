//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class ReducibleOfTests: XCTestCase {
	func testReduction() {
		let sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9]
		XCTAssertEqual(reduce(ReducibleOf(sequence), 0, (+)), 45)
	}
}
