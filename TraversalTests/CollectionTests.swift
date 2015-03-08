//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class CollectionTests: XCTestCase {
	func testCountingFiniteStreams() {
		let stream: Stream<Int> = [ 1, 2, 3 ]
		XCTAssertEqual(count(stream), 3)
	}

	func testCanConstructRangesOverFiniteStreams() {
		let stream: Stream<Int> = [ 1, 2, 3 ]
		XCTAssertEqual(count(indices(stream)), 3)
	}

	func testFindOverFiniteStreams() {
		let stream: Stream<Int> = [ 1, 2, 3 ]
		XCTAssertTrue(find(stream, 2) != nil)
	}
}


// MARK: - Imports

import Traversal
import XCTest
