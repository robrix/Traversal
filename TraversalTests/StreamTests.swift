//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

class StreamTests: XCTestCase {
	func testStreams() {
		let sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9]
		let reducible = ReducibleOf(sequence: sequence)
		let stream = Stream(reducible)

		XCTAssertEqual(first(stream)!, 1)
		XCTAssertEqual(first(stream)!, 1)
		XCTAssertEqual(first(dropFirst(stream))!, 2)
		XCTAssertEqual(first(dropFirst(stream))!, 2)
		XCTAssertEqual(first(dropFirst(dropFirst(dropFirst(stream))))!, 4)

		var n = 0
		for (a, b) in Zip2(stream, sequence) {
			XCTAssertEqual(a, b)
			n++
		}
		XCTAssertEqual(Array(stream), sequence)
		XCTAssertEqual(n, sequence.count)
	}

	func testEffectfulStreams() {
		var effects = 0
		let sequence = SequenceOf<Int> {
			GeneratorOf {
				if effects < 5 {
					effects++
					return effects
				}
				return nil
			}
		}

		XCTAssertEqual(effects, 0)

		let stream = Stream(ReducibleOf(sequence: sequence))
		XCTAssertEqual(effects, 1)

		first(stream)
		XCTAssertEqual(effects, 1)

		first(dropFirst(stream))
		XCTAssertEqual(effects, 2)

		for each in stream {}
		XCTAssertEqual(effects, 5)

		XCTAssertEqual(first(stream)!, 1)
		XCTAssertEqual(first(dropFirst(dropFirst(dropFirst(dropFirst(stream)))))!, 5)
		XCTAssertNil(first(dropFirst(dropFirst(dropFirst(dropFirst(dropFirst(stream)))))))
	}

	func testStreamReduction() {
		XCTAssertEqual(Traversal.reduce(Stream(ReducibleOf(sequence: [1, 2, 3, 4])), 0, +), 10)
	}

	func testStreamReductionIsLeftReduce() {
		XCTAssertEqual(Traversal.reduce(Stream(ReducibleOf(sequence: ["1", "2", "3"])), "0", +), "0123")
	}

	func testConstructsNilFromGeneratorOfConstantNil() {
		XCTAssertTrue(Stream<Int> { nil } == Stream<Int>.Nil)
	}

	func testConstructsConsFromGeneratorOfConstantNonNil() {
		let x: Int? = 1
		XCTAssertEqual(Stream { x }.first!, x!)
	}

	func testConstructsFiniteStreamFromGeneratorOfFiniteSequence() {
		let sequence = [1, 2, 3]
		var generator = sequence.generate()
		let stream = Stream(generator.next)
		XCTAssertTrue(stream == Stream(ReducibleOf(sequence: sequence)))
		XCTAssertEqual(Traversal.reduce(stream, 0, +), 6)
	}

	func testMapping() {
		let mapped = Traversal.map(Stream(ReducibleOf(sequence: [1, 2, 3])), { $0 * 2 })
		XCTAssertEqual(reduce(mapped, 0, +), 12)
	}
}
