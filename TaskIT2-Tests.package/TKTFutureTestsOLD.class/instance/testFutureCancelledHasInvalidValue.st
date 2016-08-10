tests
testFutureCancelledHasInvalidValue
	| future |
	future := [ (Delay forMilliseconds: 100) wait ] asTask run.
	future cancel.
	self assert: (future value isKindOf: TKTCancelledFutureValue)