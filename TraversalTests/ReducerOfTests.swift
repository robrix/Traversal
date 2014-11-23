//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

final class ReducerOfTests: XCTestCase {
	let reducible = ReducibleOf(sequence: [[1, 2], [2, 3], [3, 4]])
	lazy var reducer: ReducerOf<ReducibleOf<[Int]>, ReducibleOf<Int>> = {
		return ReducerOf(self.reducible) {
			ReducibleOf(sequence: $0)
		}
	}()

	func testReducesEachElement() {
		XCTAssertEqual(reduce(reducer, 0, +), 15)
	}

	func testReducesInOrder() {
		XCTAssertEqual(reduce(reducer, "", { $0 + toString($1) }), "122334")
	}
}
