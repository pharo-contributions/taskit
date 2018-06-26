schedulling
getAvailableWorker
	| worker |
	worker := self freeWorkers
		nextIfNone: [ self size < poolMaxSize
				ifTrue: [ self newWorker ]
				ifFalse: [ self freeWorkers next ] ].
	^ worker