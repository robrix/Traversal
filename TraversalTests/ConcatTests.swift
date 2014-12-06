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

	func testInfixConcatenationOfNilAndNilIsNil() {
		XCTAssertEqual([Int]() + (nil ++ nil), [])
	}

	func testInfixConcatenationOfNilAndXIsX() {
		XCTAssertEqual([Int]() + (nil ++ Stream.unit(0)), [0])
	}

	func testInfixConcatenationOfXAndNilIsX() {
		XCTAssertEqual([Int]() + (Stream.unit(0) ++ nil), [0])
	}

	func testInfixConcatenationOfXAndyIsXY() {
		XCTAssertEqual([Int]() + (Stream.unit(0) ++ Stream.unit(1)), [0, 1])
	}

	func testInfixConcatenation() {
		let concatenated = Stream([1, 2, 3]) ++ Stream([4, 5, 6])
		XCTAssertEqual(Traversal.reduce(concatenated, "0", { $0 + toString($1) }), "0123456")
	}
}
