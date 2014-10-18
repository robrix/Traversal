//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class LatchTests: XCTestCase {
	func testLatchReductionIgnoresPastValues() {
		var latch = Latch(value: 1)
		latch.value = 2

		XCTAssertEqual(reduce(latch, 0, +), 2)
	}
}
