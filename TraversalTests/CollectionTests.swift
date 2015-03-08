//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class CollectionTests: XCTestCase {
	func testCountingFiniteStreams() {
		let stream: Stream<Int> = [ 1, 2, 3 ]
		XCTAssertEqual(count(stream), 3)
	}
}


// MARK: - Imports

import Traversal
import XCTest
