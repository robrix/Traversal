//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Traversal
import XCTest

struct ReducibleOfThree<T>: ReducibleType {
	let elements: (T, T, T)

	typealias Element = T
	func reducer<Result>() -> ((Result, (Result, Element) -> Either<Result, Result>) -> Result) -> ((Result, (Result, Element) -> Either<Result, Result>) -> Result) {
		var generator1 = GeneratorOfOne(elements.0)
		var generator2 = GeneratorOfOne(elements.1)
		var generator3 = GeneratorOfOne(elements.2)
		return { recur in
			{ initial, combine in
				(generator1.next() ?? generator2.next() ?? generator3.next()).map { combine(initial, $0).either(id, id) } ?? initial
			}
		}
	}
}

class StreamTests: XCTestCase {
	func testConstructionWithReducibleType() {
		let stream = Stream(ReducibleOfThree(elements: (cons(1, cons(2, Stream.Nil)), cons(2, cons(3, Stream.Nil)), cons(3, cons(4, Stream.Nil)))))
		XCTAssertEqual(Traversal.reduce(stream, "0") { into, each in
			Traversal.reduce(each, into) { $0 + toString($1) }
		}, "0122334")
	}

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
			n++
			XCTAssertEqual(a, b)
			XCTAssertEqual(n, a)
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
		XCTAssertEqual(effects, 5)
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
		XCTAssertEqual(Traversal.reduce(map(stream, toString), "", +), "123")
	}

	func testMapping() {
		let mapped = Traversal.map(Stream(ReducibleOf(sequence: [1, 2, 3])), { $0 * 2 })
		XCTAssertEqual(reduce(mapped, 0, +), 12)
	}

	func testCons() {
		let stream = cons(0, Stream.Nil)
		XCTAssertEqual(first(stream)!, 0)
		XCTAssert(dropFirst(stream) == Stream.Nil)
	}

	func testStreamToReducibleOfToStream() {
		let stream = cons(1, cons(2, cons(3, Stream.Nil)))
		XCTAssert([] + stream == [1, 2, 3])
		XCTAssert([] + sequence(ReducibleOf(stream)) == [] + stream)
		XCTAssert(Stream(ReducibleOf(stream)) == stream)
	}
}
