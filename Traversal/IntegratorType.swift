//  Copyright (c) 2014 Rob Rix. All rights reserved.

public protocol IntegratorType {
	typealias Integral
	typealias Differential

	var integral: Integral { get }
	func integrate(differential: Differential) -> Self
}


/// Appends the elements of a `reducible` into a `collection`.
public func append<E: ExtensibleCollectionType, R: ReducibleType where R.Element == E.Generator.Element>(collection: E, reducible: R) -> E {
	return reduce(reducible, collection) { $0 + [$1] }
}

public func integrate<Into: IntegratorType, R: ReducibleType where R.Element == Into.Differential>(initial: Into, from: R) -> Into.Integral {
	return reduce(from, initial) { into, each in
		into.integrate(each)
	}.integral
}

public struct IntegratorOf<Integral, Differential>: IntegratorType {
	public init(_ integral: Integral, _ integrator: (Integral, Differential) -> Integral) {
		self.integral = integral
		self.integrator = integrator
	}

	public func integrate(differential: Differential) -> IntegratorOf {
		return IntegratorOf(integrator(integral, differential), integrator)
	}


	public let integral: Integral


	// MARK: Private

	private let integrator: (Integral, Differential) -> Integral
}


public func appender<E: ExtensibleCollectionType>(collection: E) -> IntegratorOf<E, E.Generator.Element> {
	return IntegratorOf(collection) { (var into, each) in
		into.append(each)
		return into
	}
}

func extender<E: ExtensibleCollectionType>(inout collection: E) -> IntegratorOf<E, E.Generator.Element> {
	return IntegratorOf(collection) { (var into, each) in
		collection.append(each)
		return collection
	}
}
