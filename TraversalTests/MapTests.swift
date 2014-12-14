//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Prelude
import Traversal
import XCTest

class MapTests: XCTestCase {
	func testMappingWithIdentity() {
		let sequence = [1, 2, 3, 4]
		let reducible = Stream(sequence)
		let mapped = Traversal.map(reducible, id)
		XCTAssertEqual(reduce(mapped, 0, +), 10)
	}

	func testMappingToAnotherType() {
		let sequence = [1, 2, 3, 4]
		let reducible = Stream(sequence)
		let mapped = Traversal.map(reducible) { [$0] }
		XCTAssertEqual(reduce(mapped, []) { $0 + $1 }, sequence)
	}

	func testStreamsOfMaps() {
		XCTAssertEqual(reduce(Traversal.map(Stream([1, 2, 3, 4]), toString), "0", +), "01234")
	}
}
