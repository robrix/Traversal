//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

final class IntegratorTests: XCTestCase {
	func testAppendIntegration() {
		XCTAssertEqual(integrate(appender([Int]()), Stream([1, 2, 3])), [1, 2, 3])
	}
}
