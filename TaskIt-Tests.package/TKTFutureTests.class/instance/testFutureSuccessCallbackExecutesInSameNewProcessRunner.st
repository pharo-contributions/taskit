tests-callbacks
testFutureSuccessCallbackExecutesInSameNewProcessRunner
	| runner future currentRunner |
	runner := TKTNewProcessTaskRunner new.
	future := runner future: [ 1 + 1 ].
	future onSuccessDo: [ :r | currentRunner := TKTConfiguration runner ].
	future waitForCompletion: 1 second.
	self assert: currentRunner equals: runner