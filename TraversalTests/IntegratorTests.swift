//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

final class IntegratorTests: XCTestCase {
	func testAppendIntegration() {
		let integrable = IntegratorOf([Int]()) { (var into: [Int], each: Int) -> [Int] in
			into.append(each)
			return into
		}
		XCTAssertEqual(integrate(integrable, Stream([1, 2, 3])), [1, 2, 3])
	}
}
