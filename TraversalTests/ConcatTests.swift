//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class ConcatTests: XCTestCase {
	func test0aryConcat() {
		let reducible = Stream([ Stream([]) ])
		XCTAssertEqual(reduce(map(concat(reducible), toString), "", +), "")
	}

	func test1aryConcat() {
		let reducible = Stream([ Stream([1]) ])
		XCTAssertEqual(reduce(map(concat(reducible), toString), "", +), "1")
	}

	func test2aryConcat() {
		let reducible = concat(Stream([ Stream([1, 2]) ]))
		XCTAssertEqual(reduce(reducible, "0") { $0 + toString($1) }, "012")
	}

	func test2arySplitConcat() {
		let reducible = Stream([ Stream([1]), Stream([2]) ])
		XCTAssertEqual(reduce(map(concat(reducible), toString), "0", +), "012")
	}

	func test3aryConcat() {
		let reducible = Stream([ Stream([1, 2, 3]) ])
		XCTAssertEqual(reduce(map(concat(reducible), toString), "0", +), "0123")
	}

	func test3arySplitConcat() {
		let reducible = Stream([ Stream([1]), Stream([2]), Stream([3]) ])
		XCTAssertEqual(reduce(map(concat(reducible), toString), "0", +), "0123")
	}
	
	func testConcatOverReducibles() {
		let sequence = [[1, 2], [3], [], [4]]
		let reducible = Stream(map(sequence) {
			Stream($0)
		})
		let concatenated = concat(reducible)
		XCTAssertEqual(reduce(concatenated, 0, +), 10)
		let mapped = map(concatenated, toString)
		let joined = join(", ", mapped)
		XCTAssertEqual(reduce(joined, "0", +), "01, 2, 3, 4")
	}

	func testInfixConcatenation() {
		let concatenated = Stream([10, 5, 3]) ++ Stream([2, 20, 20])
		let mapped = join(", ", Traversal.map(concatenated, toString))
		XCTAssertEqual(reduce(mapped, "0", +), "010, 5, 3, 2, 20, 20")
	}
}
