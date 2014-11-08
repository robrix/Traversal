//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class JoinTests: XCTestCase {
	func testJoining() {
		let joined = Traversal.join(1, ReducibleOf(sequence: [1, 2, 3]))
		XCTAssertEqual(reduce(joined, 0, +), 8)
	}
}
