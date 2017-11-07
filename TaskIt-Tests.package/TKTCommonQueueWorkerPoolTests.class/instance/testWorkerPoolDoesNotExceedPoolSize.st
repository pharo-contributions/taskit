tests
testWorkerPoolDoesNotExceedPoolSize
	| pool |
	pool := TKTCommonQueueWorkerPool new.
	pool poolMaxSize: 4.
	pool start.
	((1 to: 100) collect: [ :i | pool future: [ 1 + 1 ] ]) do: [ :future | future waitForCompletion: 1 second ].
	1 second wait.
	self assert: pool size equals: 4