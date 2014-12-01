//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class JoinTests: XCTestCase {
	func testJoining() {
		let joined = Traversal.join(", ", Traversal.map(Stream([1, 2, 3]), toString))
		XCTAssertEqual(Traversal.reduce(joined, "0", +), "01, 2, 3")
	}
}
