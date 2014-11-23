//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class FlattenMapTests: XCTestCase {
	func testFlattenMapAsConcat() {
		let sequence = [[1], [2], [3, 4], [5, 6], [], [7, 8, 9]]
		let reducible = ReducibleOf(sequence: sequence)
		let concatenated = flattenMap(reducible, id)
		XCTAssertEqual(reduce(concatenated, 0, +), 45)
	}

	func testFlattenMapAsFilter() {
		let sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9]
		let reducible = ReducibleOf(sequence: sequence)
		let filtered = flattenMap(reducible) {
			$0 % 2 == 0 ? [] : [$0]
		}
		XCTAssertEqual(reduce(filtered, 0, +), 25)
	}

	func testFlattenMapAsMap() {
		let sequence = [1, 2, 3, 4]
		let reducible = ReducibleOf(sequence: sequence)
		let mapped = flattenMap(reducible) {
			[ $0 * 2 ]
		}
		XCTAssertEqual(reduce(mapped, 0, +), 20)
	}

	func testFlattenMapTraversesElementsInOrder() {
		let flattenMapped = flattenMap(ReducibleOf(sequence: [[1, 2], [3], [], [4]])) {
			ReducibleOf(sequence: map($0, toString))
		}
		XCTAssertEqual(reduce(flattenMapped, "0", +), "01234")
	}
}
