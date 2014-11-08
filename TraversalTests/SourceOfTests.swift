//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class SourceOfTests: XCTestCase {
	var effects: Int = 0 {
		didSet {
			source.invalidate()
		}
	}

	private var source: SourceOf<Int>!

	override func setUp() {
		source = SourceOf { self.effects }
		effects = 0
	}

	func testReducesOverItsCurrentSample() {
		XCTAssertEqual(reduce(source, 0, +), 0)
		effects = 1
		XCTAssertEqual(reduce(source, 1, *), 1)
	}

	func testNotifiesObserversOnInvalidation() {
		var observances = 0
		source.connect {
			observances += 1
		}
		XCTAssertEqual(observances, 0)
		effects = 1
		XCTAssertEqual(observances, 1)
		effects = 12
		XCTAssertEqual(observances, 2)
	}
}
