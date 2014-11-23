//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class ReducibleOfTests: XCTestCase {
	func testConstructionFromSequenceType() {
		let sequence = [1, 2, 3, 4]
		XCTAssertEqual(reduce(ReducibleOf(sequence: sequence), 0, +), 10)
		XCTAssertEqual(reduce(map(ReducibleOf(sequence: sequence), toString), "0", +), "01234")
	}

	func testConstructionFromReducibleType() {
		let sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9]
		let reducible = ReducibleOf(sequence: sequence)
		let outer = ReducibleOf(reducible)
		XCTAssertEqual(reduce(outer, 0, +), 45)
	}
}
