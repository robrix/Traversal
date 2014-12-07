//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class ZipTests: XCTestCase {
	func testZipOfTwoParameters() {
		let r = Stream([1, 2, 3])
		let zipped = zip(r, r)
		let mapped = Traversal.map(zipped, +)
		XCTAssertEqual(reduce(mapped, 0, +), 12)
	}
}
