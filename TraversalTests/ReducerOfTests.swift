//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

final class ReducerOfTests: XCTestCase {
	let reducible = Stream([[1, 4], [2, 5], [3, 6]])
	lazy var reducer: ReducerOf<Int> = {
		return ReducerOf(self.reducible) {
			Stream($0)
		}
	}()

	func testReducesEachElement() {
		XCTAssertEqual(reduce(reducer, 0, +), 21)
	}

	func testReducesInOrder() {
		XCTAssertEqual(reduce(reducer, "0", { $0 + toString($1) }), "0142536")
	}
}
