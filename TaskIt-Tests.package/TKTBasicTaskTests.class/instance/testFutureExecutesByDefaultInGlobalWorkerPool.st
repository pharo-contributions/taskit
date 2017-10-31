tests
testFutureExecutesByDefaultInGlobalWorkerPool
	| future |
	future := [ TKTConfiguration runner ] future.
	self assert: (future synchronizeTimeout: 1 second) equals: TKTConfiguration runner