tests-callbacks
testFutureExecutesInNewProcessRunner
	| runner future currentRunner |
	runner := TKTNewProcessTaskRunner new.
	future := runner future: [ currentRunner := TKTConfiguration runner ].
	future waitForCompletion: 1 second.
	self assert: currentRunner equals: runner