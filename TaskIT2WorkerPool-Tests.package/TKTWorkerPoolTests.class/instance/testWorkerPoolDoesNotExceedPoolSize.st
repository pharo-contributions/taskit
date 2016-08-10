as yet unclassified
testWorkerPoolDoesNotExceedPoolSize

	| pool |
	pool := TKTWorkerPool new.
	pool poolMaxSize: 4.
	pool start.
		
	((1 to: 10) collect: [:i | pool future: [ 1 + 1 ] ])
		do: [ :future | future waitForCompletion: 500 milliSeconds. ].
	
	self assert: pool size equals: 4