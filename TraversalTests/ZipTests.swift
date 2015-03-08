//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Prelude
import Traversal
import XCTest

class ZipTests: XCTestCase {
	func testZipOfTwoParameters() {
		let r = Stream([1, 2, 3])
		let zipped = Traversal.zip(r, r)
		let mapped = Traversal.map(zipped, +)
		XCTAssertEqual(reduce(mapped, 0, +), 12)
	}

	func testZipOfThreeParameters() {
		let s: Stream = [1, 2, 3]
		let zipped = zip(s, map(s, 2 |> curry(*)), map(s, 3 |> curry(*)))
		XCTAssertEqual(reduce(Traversal.map(zipped, toString), "", (+)), "(1, 2, 3)(2, 4, 6)(3, 6, 9)")
	}
}
