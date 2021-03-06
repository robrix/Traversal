//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

final class AppendingTests: XCTestCase {
	func testExtending() {
		var extensible = [Int]()
		extensible += Stream([1, 2, 3])
		XCTAssertEqual(extensible, [1, 2, 3])
	}

	func testAppending() {
		let array = [0] + Stream([1, 2, 3])
		XCTAssertEqual(array, [0, 1, 2, 3])
	}
}
