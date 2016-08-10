tests
testFutureValueTimeoutsError
	| future |
	future := [ (Delay forMilliseconds: 100) wait ] run.
	self should: [ future valueTimeoutMilliseconds: 20 ] raise: TKTTimeoutError