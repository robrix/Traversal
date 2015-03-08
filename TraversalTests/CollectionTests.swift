//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class CollectionTests: XCTestCase {
	let empty: Stream<Int> = nil
	let finite: Stream<Int> = [ 1, 2, 3 ]

	func testCountingFiniteStreams() {
		XCTAssertEqual(count(finite), 3)
	}

	func testCanConstructRangesOverFiniteStreams() {
		XCTAssertEqual(count(indices(finite)), 3)
	}

	func testFindOverFiniteStreams() {
		XCTAssertTrue(find(finite, 2) != nil)
	}

	func testIsEmptyOverEmptyStreams() {
		XCTAssertTrue(isEmpty(empty))
	}
}


// MARK: - Imports

import Traversal
import XCTest
