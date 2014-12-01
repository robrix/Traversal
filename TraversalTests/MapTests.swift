//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class MapTests: XCTestCase {
	func testMappingWithIdentity() {
		let sequence = [1, 2, 3, 4]
		let reducible = Stream(sequence)
		let mapped = Traversal.map(reducible, id)
		XCTAssertEqual(Traversal.reduce(mapped, 0, +), 10)
	}

	func testMappingToAnotherType() {
		let sequence = [1, 2, 3, 4]
		let reducible = Stream(sequence)
		let mapped = Traversal.map(reducible) { [$0] }
		XCTAssertEqual(Traversal.reduce(mapped, []) { $0 + $1 }, sequence)
	}
}
