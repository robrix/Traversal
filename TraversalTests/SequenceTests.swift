//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

final class SequenceTests: XCTestCase {
	func testSequencesOfReducibles() {
		let reducible = ReducibleOf(sequence: [1, 2, 3]) ++ ReducibleOf(sequence: [4, 5, 6])
		var sum = 0
		for each in sequence(reducible) {
			sum += each
		}
		XCTAssertEqual(sum, 21)
	}
}
