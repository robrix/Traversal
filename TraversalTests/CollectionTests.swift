//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class CollectionTests: XCTestCase {
	let empty: Stream<Int> = nil
	let finite: Stream<Int> = [ 1, 2, 3 ]
	let infinite: Stream<Int> = Stream { 0 }

	func testCountingFiniteStreams() {
		XCTAssertEqual(count(finite), 3)
	}

	func testCountingEmptyStreams() {
		XCTAssertEqual(count(empty), 0)
	}

	func testRangesOverFiniteStreams() {
		XCTAssertEqual(count(indices(finite)), 3)
	}

	func testRangesOverInfiniteStreams() {
		let i = indices(infinite)
		XCTAssertEqual(i.endIndex, i.endIndex.successor())
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
