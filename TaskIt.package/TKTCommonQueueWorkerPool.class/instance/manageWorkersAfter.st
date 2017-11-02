schedulling
manageWorkersAfter
	| free |
	free := workers select: #isFree.
	free size > (poolMaxSize / 2)
		ifTrue: [ self removeIdleWorker ]