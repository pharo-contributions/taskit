tests-callbacks
testFutureSuccessCallbackExecutesInSameWorkerRunner
	| runner future currentRunner |
	runner := TKTWorker new start.
	future := runner future: [ 1 + 1 ].
	future onSuccessDo: [ :r | currentRunner := TKTConfiguration runner ].
	future waitForCompletion: 1 second.
	self assert: currentRunner equals: runner