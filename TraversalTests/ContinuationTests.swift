//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Prelude
import Traversal
import XCTest

final class ContinuationTests: XCTestCase {
	func testWhatsYourNameGreetsNonEmptyStrings() {
		XCTAssertEqual(whatsYourName("Pixel"), "Welcome, Pixel!")
	}

	func testWhatsYourNameScoldsTheEmptyString() {
		XCTAssertEqual(whatsYourName(""), "You forgot to tell me your name!")
	}
}


// MARK: Continuation fixtures.

// Translated from the Haskell examples.

/// Defined over `Continuation` because we can’t type `Monad` without higher-rank types.
func when<Result>(condition: Bool, then: Continuation<Result, ()>) -> Continuation<Result, ()> {
	return condition ? then : .unit(())
}

/// Validates a name, calling the `exit` function if it could not be validated.
func validateName(name: String, exit: String -> Continuation<String, ()>) -> Continuation<String, ()> {
	return when(countElements(name) == 0, exit("You forgot to tell me your name!"))
}

/// Greets you if you give it a non-empty name, scolds you otherwise.
func whatsYourName(name: String) -> String {
	// This really wants do notation.
	return Continuation<String, String>.callCC { exit in // calling exit will escape from the computation with the passed value instead of continuing on
		validateName(name, exit)
			.bind { _ in .unit("Welcome, \(name)!") } // if the name was validated, return a greeting
	}.run(id) // extract the value from the continuation
}
