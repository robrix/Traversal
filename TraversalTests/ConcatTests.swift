//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class ConcatTests: XCTestCase {
	func testConcat() {
		let sequence = [[1, 2], [3], [], [4]]
		let reducible = ReducibleOf(sequence: sequence)
		let concatenated = concat(reducible)
		XCTAssertEqual(reduce(concatenated, 0, +), 10)
	}

	func testInfixConcatenation() {
		let concatenated = ReducibleOf(sequence: [10, 5, 3]) ++ ReducibleOf(sequence: [2, 20, 20])
		let mapped = Traversal.map(concatenated, toString)
		XCTAssertEqual(Traversal.reduce(mapped, "", +), "105322020")
	}
}
