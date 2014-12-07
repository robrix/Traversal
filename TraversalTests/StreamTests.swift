//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Either
import Memo
import Prelude
import Traversal
import XCTest

struct ReducibleOfThree<T>: ReducibleType {
	let elements: (T, T, T)

	func reducer<Result>() -> Reducible<ReducibleOfThree, Result, T>.Enumerator -> Reducible<ReducibleOfThree, Result, T>.Enumerator {
		var generator1 = GeneratorOfOne(elements.0)
		var generator2 = GeneratorOfOne(elements.1)
		var generator3 = GeneratorOfOne(elements.2)
		return { recur in
			{ reducible, initial, combine in
				(generator1.next() ?? generator2.next() ?? generator3.next()).map { combine(initial, $0).either(id, { recur(reducible, $0, combine) }) } ?? initial
			}
		}
	}
}

class StreamTests: XCTestCase {
	func testConstructionWithReducibleType() {
		let stream = Stream(ReducibleOfThree(elements: (Stream([1, 4]), Stream([2, 5]), Stream([3, 6]))))
		XCTAssertEqual(Traversal.reduce(stream, "0") { into, each in
			Traversal.reduce(each, into) { $0 + toString($1) }
		}, "0142536")
	}

	func testConstructionWithReducer() {
		let stream = Stream(ReducibleOfThree(elements: (Stream([1, 4]), Stream([2, 5]), Stream([3, 6]))))
		XCTAssertEqual(Traversal.reduce(Stream(ReducerOf(stream, id)), "0", { $0 + toString($1) }), "0142536")

		let s = Stream([nil, Stream([1, 4]), Stream([2, 5]), Stream([3, 6])])
		XCTAssertEqual(Traversal.reduce(Stream(ReducerOf(s, id)), "0", { $0 + toString($1) }), "0142536")
	}

	func testStreams() {
		let seq = [1, 2, 3, 4, 5, 6, 7, 8, 9]
		let stream = Stream(seq)

		XCTAssertEqual(stream.first ?? -1, 1)
		XCTAssertEqual(stream.first ?? -1, 1)
		XCTAssertEqual(stream.rest.first ?? -1, 2)
		XCTAssertEqual(stream.rest.first ?? -1, 2)
		XCTAssertEqual(stream.rest.rest.rest.first ?? -1, 4)

		var n = 0
		for (a, b) in Zip2(sequence(stream), seq) {
			n++
			XCTAssertEqual(a, b)
			XCTAssertEqual(n, a)
		}
		XCTAssertEqual(Array(sequence(stream)), seq)
		XCTAssertEqual(n, seq.count)
	}

	func testEffectfulStreams() {
		var effects = 0
		let seq = SequenceOf<Int> {
			GeneratorOf {
				if effects < 5 {
					effects++
					return effects
				}
				return nil
			}
		}

		XCTAssertEqual(effects, 0)

		let stream = Stream(seq)
		XCTAssertEqual(effects, 1)

		let _ = stream.first
		XCTAssertEqual(effects, 1)

		let _ = stream.rest.first
		XCTAssertEqual(effects, 2)

		for each in sequence(stream) {}
		XCTAssertEqual(effects, 5)

		XCTAssertEqual(stream.first ?? -1, 1)
		XCTAssertEqual(stream.rest.rest.rest.rest.first ?? -1, 5)
		XCTAssertNil(stream.rest.rest.rest.rest.rest.first)
		XCTAssertEqual(effects, 5)
	}

	func testStreamReduction() {
		XCTAssertEqual(Traversal.reduce(Stream([1, 2, 3, 4]), 0, +), 10)
	}

	func testStreamReductionIsLeftReduce() {
		XCTAssertEqual(Traversal.reduce(Stream(["1", "2", "3"]), "0", +), "0123")
		XCTAssertEqual(Traversal.reduce(Stream.cons("1", Stream.cons("2", Stream.unit("3"))), "0", +), "0123")
	}

	func testConstructsNilFromGeneratorOfConstantNil() {
		XCTAssertTrue(Stream<Int> { nil } == nil)
	}

	func testConstructsConsFromGeneratorOfConstantNonNil() {
		let x: Int? = 1
		XCTAssertEqual(Stream { x }.first ?? -1, 1)
	}

	func testConstructsFiniteStreamFromGeneratorOfFiniteSequence() {
		let seq = [1, 2, 3]
		var generator = seq.generate()
		let stream = Stream { generator.next() }
		XCTAssertEqual(Array(sequence(stream)), seq)
		XCTAssertEqual(Traversal.reduce(stream, 0, +), 6)
		XCTAssertEqual(Traversal.reduce(map(stream, toString), "0", +), "0123")
	}

	func testMapping() {
		let mapped = Traversal.map(Stream([1, 2, 3]), { $0 * 2 })
		XCTAssertEqual(reduce(mapped, 0, +), 12)
	}

	func testCons() {
		let stream = Stream.unit(0)
		XCTAssertEqual(stream.first ?? -1, 0)
		XCTAssert(stream.rest == nil)
	}

	let fibonacci: Stream<Int> = fix { fib in
		{ x, y in Stream.cons(x + y, fib(y, x + y)) }
	}(0, 1)

	func testTake() {
		let stream = fibonacci.take(3)
		XCTAssertTrue(stream == Stream([1, 2, 3]))
	}

	func testTakeOfZeroIsNil() {
		let stream = fibonacci.take(0)
		XCTAssertTrue(stream == nil)
	}

	func testTakeOfNegativeIsNil() {
		let stream = fibonacci.take(-1)
		XCTAssertTrue(stream == nil)
	}

	func testDrop() {
		let stream = fibonacci.drop(3)
		XCTAssertEqual(stream.first ?? -1, 5)
	}

	func testDropOfZeroIsSelf() {
		let stream = Stream([1, 2, 3])
		XCTAssertTrue(stream.drop(0) == stream)
	}

	func testDropOfNegativeIsSelf() {
		let stream = Stream([1, 2, 3])
		XCTAssertTrue(stream.drop(-1) == stream)
	}

	func testMap() {
		XCTAssertEqual(Array(sequence(fibonacci.map { $0 * $0 }.take(3))), [1, 4, 9])
	}

	func testConcatenationOfNilAndNilIsNil() {
		XCTAssertEqual([Int]() + (nil ++ nil), [])
	}

	func testConcatenationOfNilAndXIsX() {
		XCTAssertEqual([Int]() + (nil ++ Stream.unit(0)), [0])
	}

	func testConcatenationOfXAndNilIsX() {
		XCTAssertEqual([Int]() + (Stream.unit(0) ++ nil), [0])
	}

	func testConcatenationOfXAndYIsXY() {
		XCTAssertEqual([Int]() + (Stream.unit(0) ++ Stream.unit(1)), [0, 1])
	}

	func testConcatenation() {
		let concatenated = Stream([1, 2, 3]) ++ Stream([4, 5, 6])
		XCTAssertEqual(Traversal.reduce(concatenated, "0", { $0 + toString($1) }), "0123456")
	}

	func testFlattenMap() {
		let inner = Stream([1, 2, 3])
		XCTAssertEqual([Int]() + inner.flattenMap({ _ in inner }), [1, 2, 3, 1, 2, 3, 1, 2, 3])
	}

	func testFoldLeft() {
		XCTAssertEqual(Stream([1, 2, 3]).foldLeft("0", { $0 + toString($1) }), "0123")
	}

	func testFoldLeftWithEarlyTermination() {
		XCTAssertEqual(Stream([1, 2, 3]).foldLeft("0", { $0 + toString($1) } >>> Either.left), "01")
	}

	func testFoldRight() {
		XCTAssertEqual(Stream([1, 2, 3]).foldRight("4", { toString($0) + $1 }), "1234")
	}

	func testFoldRightWithEarlyTermination() {
		XCTAssertEqual(Stream([1, 2, 3]).foldRight("4", { (each: Int, rest: Memo<String>) in toString(each) }), "1")
	}

	func testUnfoldRight() {
		let fib = Stream.unfoldRight((0, 1)) { x, y in
			(x + y, (y, x + y))
		}
		XCTAssertEqual([Int]() + fib.take(5), [1, 2, 3, 5, 8])
	}

	func testUnfoldLeft() {
		let stream = Stream.unfoldLeft(5) { n in n >= 0 ? (n - 1, n) : nil }
		XCTAssertEqual([Int]() + stream, [0, 1, 2, 3, 4, 5])
	}

	func testArrayLiteralConvertible() {
		let stream: Stream<Int> = [1, 2, 3, 4, 5]
		XCTAssertEqual([Int]() + stream, [1, 2, 3, 4, 5])
	}
}
