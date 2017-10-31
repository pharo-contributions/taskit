tests-callbacks
testFutureExecutesInSameLocalProcessRunner

	| runner future currentRunner |
	runner := TKTLocalProcessTaskRunner new.
	future := runner future: [ currentRunner := TKTConfiguration runner].	
	future waitForCompletion: 1 second.
	
	self assert: currentRunner equals: runner