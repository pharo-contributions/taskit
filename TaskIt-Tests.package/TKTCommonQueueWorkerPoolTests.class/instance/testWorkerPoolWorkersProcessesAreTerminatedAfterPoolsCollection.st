tests
testWorkerPoolWorkersProcessesAreTerminatedAfterPoolsCollection
	| pool workerProcess |
	pool := TKTCommonQueueWorkerPool createDefault.
	(pool future: (MessageSend receiver: self selector: #yourself)) waitForCompletion: 1 second.
	workerProcess := pool workers anyOne process process.
	pool := nil.
	7
		timesRepeat: [ Smalltalk garbageCollect.
			50 milliSeconds wait ].
	1 second wait.
	workerProcess isTerminated.
	self assert: workerProcess isTerminated