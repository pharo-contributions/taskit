tests
testFutureValueTimeouts
	| future |
	future := [ (Delay forMilliseconds: 100) wait ] run.
	self assert: (future valueTimeoutMilliseconds: 20 ifTimeout: [ 2 ]) equals: 2