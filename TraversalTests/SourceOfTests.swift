//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class SourceOfTests: XCTestCase {
	func testReducesOverItsCurrentSample() {
		var effects = 0
		let source = SourceOf {
			effects
		}
		XCTAssertEqual(reduce(source, 0, +), 0)
		effects = 1
		XCTAssertEqual(reduce(source, 1, *), 1)
	}
}
