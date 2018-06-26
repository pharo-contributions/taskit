tests
testWorkerPoolWorkersProcessesAreStoppedAfterPoolsCollection
	| pool workerProcess |
	pool := TKTCommonQueueWorkerPool new.
	pool name: 'Test pool', UUID new asString.
	pool poolMaxSize: 4.
	pool start.
		
	(pool future: (MessageSend receiver: self selector: #yourself))
		waitForCompletion: 1 second.

	workerProcess := WeakArray with: pool workers anyOne process process.
	
	pool := nil.
	7 timesRepeat: [Smalltalk garbageCollect. 10 milliSeconds wait ].

	self assert: workerProcess first isNil