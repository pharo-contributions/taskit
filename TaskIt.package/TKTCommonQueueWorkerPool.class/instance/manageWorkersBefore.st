schedulling
manageWorkersBefore
	| free |
	free := (workers select: #isFree) .
	free size = 0 ifTrue: [ self spawnWorkerIfNeeded ].
	
	