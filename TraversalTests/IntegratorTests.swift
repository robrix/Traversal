//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

final class IntegratorTests: XCTestCase {
	func testAppendIntegration() {
		let appended = append([], Stream([1, 2, 3]))
		XCTAssertEqual(appended, [1, 2, 3])
	}
}
