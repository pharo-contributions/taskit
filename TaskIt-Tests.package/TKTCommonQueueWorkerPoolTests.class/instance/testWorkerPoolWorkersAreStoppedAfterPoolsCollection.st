tests
testWorkerPoolWorkersAreStoppedAfterPoolsCollection

	| pool workerProcess |
	pool := TKTCommonQueueWorkerPool new.
	pool name: 'test pool', UUID new asString.
	pool poolMaxSize: 4.
	pool start.
		
	(pool future: (MessageSend receiver: self selector: #yourself))
		waitForCompletion: 1 second.

	self assert: pool workers notEmpty.
	
	workerProcess := WeakArray with: pool workers anyOne process.
	
	pool := nil.
	7 timesRepeat: [Smalltalk garbageCollect. 100 milliSeconds wait ].


	self assert: workerProcess first isNil.