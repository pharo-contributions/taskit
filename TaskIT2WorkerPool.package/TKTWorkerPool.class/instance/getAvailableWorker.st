scheduling
getAvailableWorker

	| worker |
	worker := freeWorkers nextIfNone: [
			self size < poolMaxSize
				ifTrue: [ 
						size := size + 1.
						self newWorker ]
				ifFalse: [ freeWorkers next ] ].
	busyWorkers add: worker.
	^ worker