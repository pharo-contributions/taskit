schedulling
manageWorkersAfter
	| free |
	free := workers select: #isFree.
	free size - taskQueue > (poolMaxSize / 2)
		ifTrue: [ self removeIdleWorker ]