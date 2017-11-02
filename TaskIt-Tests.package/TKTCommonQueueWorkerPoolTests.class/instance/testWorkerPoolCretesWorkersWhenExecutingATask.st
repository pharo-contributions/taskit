tests
testWorkerPoolCretesWorkersWhenExecutingATask
	| pool |
	pool := TKTCommonQueueWorkerPool new.
	pool name: 'test pool'.
	pool poolMaxSize: 4.
	pool start.
	(pool future: [ 1 ]) waitForCompletion: 1 second.
	self assert: pool workers notEmpty