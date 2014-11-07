//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class FlattenMapTests: XCTestCase {
	func testFlattenMapAsConcat() {
		let sequence = [[1], [2], [3, 4], [5, 6], [], [7, 8, 9]]
		let reducible = ReducibleOf(sequence: sequence)
		let flattenMapped = flattenMap(reducible, id)
		XCTAssertEqual(reduce(flattenMapped, 0, +), 45)
	}
}
