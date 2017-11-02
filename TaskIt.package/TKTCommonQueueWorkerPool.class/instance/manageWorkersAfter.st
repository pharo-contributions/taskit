schedulling
manageWorkersAfter
	| free |
	free := workers select: #isFree.
	free size - taskQueue size > (poolMaxSize / 2)
		ifTrue: [ self removeIdleWorker ]