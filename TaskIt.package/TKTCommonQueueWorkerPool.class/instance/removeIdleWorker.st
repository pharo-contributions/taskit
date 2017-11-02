schedulling
removeIdleWorker
	| removing |
	removing := (workers reject: #isRunning) first.
	removing stop.
	workers remove: removing