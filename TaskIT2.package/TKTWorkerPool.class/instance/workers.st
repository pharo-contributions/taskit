accessing
workers
	
	| workerSet |
	workerSet := busyWorkers copy asSet.
	[ freeWorkers isEmpty ] whileFalse: [ workerSet add: freeWorkers next ].
	^ workerSet