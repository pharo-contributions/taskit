tests-callbacks
testFutureFailureCallbackExecutesInSameWorker
	| runner future currentRunner |
	runner := TKTWorker new start.
	future := runner future: [ Error signal ].
	future onFailureDo: [ :r | currentRunner := TKTConfiguration runner ].
	future waitForCompletion: 1 second.
	100 milliSeconds wait.
	self assert: currentRunner equals: runner