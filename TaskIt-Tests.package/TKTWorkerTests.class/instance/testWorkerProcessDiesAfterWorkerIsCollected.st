tests
testWorkerProcessDiesAfterWorkerIsCollected
	| worker future process |
	worker := TKTWorker new.
	worker start.
	process := worker process.
	worker := nil.
	7 timesRepeat: [ Smalltalk garbageCollect ].
	future := TKTFuture doing: [ [ process isRunning ] whileTrue: [ 50 milliSeconds wait ] ].
	future synchronizeTimeout: 2 seconds.
	self deny: process isRunning