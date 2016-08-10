tests
testWorkerProcessDiesAfterStop

	| worker future |
	worker := TKTWorker new.
	worker start.
	worker stop.
	
	future := TKTFuture doing: [ [ worker process isTerminated ] whileFalse: [ 50 milliSeconds wait ] ].
	future valueTimeout: 2 seconds.
	
	self assert: worker process isTerminated