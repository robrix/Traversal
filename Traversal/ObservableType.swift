//  Copyright (c) 2014 Rob Rix. All rights reserved.

public protocol ObservableType: ReducibleType {
	func connect<S: SinkType where S.Element == Element>(sink: S)
}
