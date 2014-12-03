//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Represents the remainder of a computation, enabling it to be paused and resumed as desired, as well as passed around as a first-class value.
public struct Continuation<Result, A> {
	/// Monadic return.
	public init(_ run: (A -> Result) -> Result) {
		self.run = run
	}

	/// Monadic bind.
	public func bind<B>(k: A -> Continuation<Result, B>) -> Continuation<Result, B> {
		return Continuation<Result, B> { c in
			self.run { a in
				k(a).run(c)
			}
		}
	}

	/// Applies a function (possibly `id` if `A` == `Result`) to extract the result of the computation.
	public let run: (A -> Result) -> Result

	/// …also Monadic return, but this one can be called as a free function.
	public static func unit(a: A) -> Continuation {
		return Continuation { $0(a) } // $ a
	}

	/// Map the result of a continuation.
	///
	/// I don’t know why `mapCont` in Haskell doesn’t map `Cont r a` into `Cont s a`, but it doesn’t, so we don’t either.
	public func map(f: Result -> Result) -> Continuation {
		return Continuation { f(self.run($0)) }
	}

	/// Transform the continuation passed to a computation.
	public func with<B>(f: (B -> Result) -> (A -> Result)) -> Continuation<Result, B> {
		return Continuation<Result, B> { self.run(f($0)) }
	}

	/// Calls `f` with the current continuation.
	public static func callCC<B>(f: (A -> Continuation<Result, B>) -> Continuation) -> Continuation {
		return Continuation { c in
			f { a in
				Continuation<Result, B> { _ in
					c(a)
				}
			}.run(c)
		}
	}

	// todo: delimited continuations with shift & reset: http://okmij.org/ftp/continuations/#tutorial
}
