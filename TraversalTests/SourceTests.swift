//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Either
import Memo
import Traversal
import XCTest

final class SourceTests: XCTestCase {
	func testCallsCombineWithEachValue() {
		var effects = 0
		let source = Source { ++effects }

		let mapped = Traversal.map(source) { $0.value * 2 }

		var results = [0]
		reduce(mapped, [], { into, each -> Either<[Int], [Int]> in
			results.append(each)
			return .right(into)
		})

		XCTAssertEqual(results, [0])

		source.invalidate()
		XCTAssertEqual(results, [0, 2])

		source.invalidate()
		XCTAssertEqual(results, [0, 2, 4])
	}
}
