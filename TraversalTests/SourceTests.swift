//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Either
import Memo
import Traversal
import XCTest

final class SourceTests: XCTestCase {
	func testCallsCombineWithEachValue() {
		let source = Source { NSDate.timeIntervalSinceReferenceDate() }

		let mapped = Traversal.map(source) { Int($0.value) }

		var results = [0]
		reduce(mapped, [], { into, each -> Either<[Int], [Int]> in
			results.append(results.count)
			return .left(into)
		})

		XCTAssertEqual(results, [0])

		source.invalidate()
		XCTAssertEqual(results, [0, 1])

		source.invalidate()
		XCTAssertEqual(results, [0, 1, 2])
	}
}
