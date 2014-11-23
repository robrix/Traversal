//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class JoinTests: XCTestCase {
	func testJoining() {
		let joined = join(", ", map(ReducibleOf(sequence: [1, 2, 3]), toString))
		XCTAssertEqual(reduce(joined, "0", +), "01, 2, 3")
	}
}
