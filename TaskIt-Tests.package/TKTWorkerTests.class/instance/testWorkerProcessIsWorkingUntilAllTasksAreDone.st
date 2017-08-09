tests
testWorkerProcessIsWorkingUntilAllTasksAreDone
	| worker process waitFuture |
	
	self timeLimit: 10 minutes. 
	worker := TKTWorker new.
	worker start.
	process := worker process.
	waitFuture := TKTFuture doing: [ [ process isRunning ] whileTrue: [ 50 milliSeconds wait ] ].
	worker schedule: [ 100 milliSeconds wait ].
	self assert: process taskQueue size equals: 1.
	50 milliSeconds wait.
	self assert: process taskQueue size equals: 0.
	worker := nil.
	Smalltalk garbageCollect.
	50 milliSeconds wait.
	Smalltalk garbageCollect.
	self assert: process taskQueue size equals: 0.
	self assert: process isRunning.
	waitFuture waitForCompletion: 10 second.
	self deny: process isRunning