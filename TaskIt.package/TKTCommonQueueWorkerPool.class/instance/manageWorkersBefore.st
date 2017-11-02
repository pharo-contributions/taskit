schedulling
manageWorkersBefore
	| free |
	free := workers select: #isFree.
	free size - taskQueue size <= 0
		ifTrue: [ self spawnWorkerIfNeeded ]