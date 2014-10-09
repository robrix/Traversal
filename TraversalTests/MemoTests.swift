//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class MemoTests: XCTestCase {
	func testDoesNotRepeatEffects() {
		var effects = 0
		let effectful: () -> Int = {
			effects += 1
			return effects
		}

		let memo = Memo(effectful())
		XCTAssertEqual(memo.value, 1)
		XCTAssertEqual(memo.value, 1)
	}
}
