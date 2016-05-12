tests
testFutureCancelledHasInvalidValue
	| future |
	future := [ (Delay forMilliseconds: 100) wait ] run.
	future cancel.
	self assert: (future value isKindOf: TKTCancelledFutureValue)