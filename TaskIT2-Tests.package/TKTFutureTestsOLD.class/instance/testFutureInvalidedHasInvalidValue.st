tests
testFutureInvalidedHasInvalidValue
	| future |
	future := [ 1 / 0 ] run.
	10 milliSeconds wait.
	self should: [ future value ] raise: ZeroDivide