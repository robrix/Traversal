//  Copyright (c) 2014 Rob Rix. All rights reserved.

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
		let stream = Stream(ReducibleOfThree(elements: (Stream([1, 2]), Stream([2, 3]), Stream([3, 4]))))
		XCTAssertEqual(Traversal.reduce(stream, "0") { into, each in
			Traversal.reduce(each, into) { $0 + toString($1) }
		}, "0122334")
	}

	func testConstructionWithReducerOf() {
		let stream = Stream(ReducibleOfThree(elements: (Stream([1, 4]), Stream([2, 5]), Stream([3, 6]))))
		XCTAssertEqual(Traversal.reduce(Stream(ReducerOf(stream, id)), "0") { $0 + toString($1)}, "0142536")
	}

	func testStreams() {
		let sequence = [1, 2, 3, 4, 5, 6, 7, 8, 9]
		let stream = Stream(sequence)

		XCTAssertEqual(first(stream) ?? -1, 1)
		XCTAssertEqual(first(stream) ?? -1, 1)
		XCTAssertEqual(first(dropFirst(stream)) ?? -1, 2)
		XCTAssertEqual(first(dropFirst(stream)) ?? -1, 2)
		XCTAssertEqual(first(dropFirst(dropFirst(dropFirst(stream)))) ?? -1, 4)

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

		let stream = Stream(sequence)
		XCTAssertEqual(effects, 1)

		first(stream)
		XCTAssertEqual(effects, 1)

		first(dropFirst(stream))
		XCTAssertEqual(effects, 2)

		for each in stream {}
		XCTAssertEqual(effects, 5)

		XCTAssertEqual(first(stream) ?? -1, 1)
		XCTAssertEqual(first(dropFirst(dropFirst(dropFirst(dropFirst(stream))))) ?? -1, 5)
		XCTAssertNil(first(dropFirst(dropFirst(dropFirst(dropFirst(dropFirst(stream)))))))
		XCTAssertEqual(effects, 5)
	}

	func testStreamReduction() {
		XCTAssertEqual(Traversal.reduce(Stream([1, 2, 3, 4]), 0, +), 10)
	}

	func testStreamReductionIsLeftReduce() {
		XCTAssertEqual(Traversal.reduce(Stream(["1", "2", "3"]), "0", +), "0123")
		XCTAssertEqual(Traversal.reduce(Stream.cons("1", Stream.cons("2", Stream.cons("3", Stream.Nil))), "0", +), "0123")
	}

	func testConstructsNilFromGeneratorOfConstantNil() {
		XCTAssertTrue(Stream<Int> { nil } == Stream<Int>.Nil)
	}

	func testConstructsConsFromGeneratorOfConstantNonNil() {
		let x: Int? = 1
		XCTAssertEqual(Stream { x }.first ?? -1, 1)
	}

	func testConstructsFiniteStreamFromGeneratorOfFiniteSequence() {
		let sequence = [1, 2, 3]
		var generator = sequence.generate()
		let stream = Stream { generator.next() }
		XCTAssertEqual(Array(stream), sequence)
		XCTAssertEqual(Traversal.reduce(stream, 0, +), 6)
		XCTAssertEqual(Traversal.reduce(map(stream, toString), "0", +), "0123")
	}

	func testMapping() {
		let mapped = Traversal.map(Stream([1, 2, 3]), { $0 * 2 })
		XCTAssertEqual(reduce(mapped, 0, +), 12)
	}

	func testCons() {
		let stream = Stream.cons(0, Stream.Nil)
		XCTAssertEqual(first(stream) ?? -1, 0)
		XCTAssert(dropFirst(stream) == Stream.Nil)
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
		XCTAssertTrue(stream == .Nil)
	}

	func testTakeOfNegativeIsNil() {
		let stream = fibonacci.take(-1)
		XCTAssertTrue(stream == .Nil)
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
		XCTAssertEqual(Array(fibonacci.map { $0 * $0 }.take(3)), [1, 4, 9])
	}

	func testConcatenationOfNilAndNilIsNil() {
		XCTAssertEqual([Int]() + (Stream<Int>.Nil ++ Stream<Int>.Nil), [])
	}

	func testConcatenationOfNilAndXIsX() {
		XCTAssertEqual([Int]() + (Stream.Nil ++ Stream.unit(0)), [0])
	}

	func testConcatenationOfXAndNilIsX() {
		XCTAssertEqual([Int]() + (Stream.unit(0) ++ Stream.Nil), [0])
	}

	func testConcatenationOfXAndyIsXY() {
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

	func testFoldRight() {
		XCTAssertEqual(Stream([1, 2, 3]).foldRight("4", { toString($0) + $1 }), "1234")
	}

	func testUnfold() {
		let fib = Stream.unfold((0, 1)) { x, y in
			((y, x + y), x + y)
		}
		XCTAssertEqual([Int]() + fib.take(5), [1, 2, 3, 5, 8])
	}
}
