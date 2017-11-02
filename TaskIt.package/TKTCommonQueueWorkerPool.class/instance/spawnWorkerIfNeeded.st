schedulling
spawnWorkerIfNeeded
	workers size < poolMaxSize
		ifTrue: [ self newWorker ]