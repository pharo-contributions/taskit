tests
testWorkerProcessIsWorkingUntilAllTasksAreDone

	| worker process waitFuture |
	worker := TKTWorker new.
	worker start.
	process := worker process.
	
	waitFuture := TKTFuture doing: [ [ process isRunning ] whileTrue: [ 50 milliSeconds wait ] ].
	
	worker schedule: [ 100 milliSeconds wait ].
	
	
	worker := nil.
	Smalltalk garbageCollect.
	50 milliSeconds wait.
	self assert: process isRunning.
	
	waitFuture synchronizeTimeout: 200 milliSeconds.
	
	self deny: process isRunning.