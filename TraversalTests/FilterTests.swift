//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class FilterTests: XCTestCase {
	func testFilterAcceptingAll() {
		let sequence = [1, 2, 3, 4]
		let reducible = Stream(sequence)
		let filtered = Traversal.filter(reducible, acceptAll)
		let reduced = Traversal.reduce(filtered, []) { $0 + [$1] }
		XCTAssertEqual(reduced, sequence)
	}

	func testFilterRejectingAll() {
		let sequence = [1, 2, 3, 4]
		let reducible = Stream(sequence)
		let filtered = Traversal.filter(reducible, rejectAll)
		XCTAssertEqual(Traversal.reduce(filtered, 0, +), 0)
	}

	func testFilterAcceptingSome() {
		let sequence: [Int?] = [1, nil, 3, nil]
		let reducible = Stream(sequence)
		let filtered = Traversal.filter(reducible, rejectNil)
		XCTAssertEqual(Traversal.reduce(filtered, 0) { $0 + ($1 ?? 0) }, 4)
	}
}
