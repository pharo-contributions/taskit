tests
testWorkerProcessDiesAfterStop

	| worker future |
	worker := TKTWorker new.
	worker start.
	worker stop.
	future := TKTFuture doing: [ [ worker isRunning ] whileTrue: [ 50 milliSeconds wait ] ].
	future synchronizeTimeout: 2 seconds.
	self deny: worker isRunning