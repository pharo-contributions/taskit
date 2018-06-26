schedulling
manageWorkersBefore
	| free toremove |
	toremove := workers reject: #isRunning.
	toremove isEmpty
		ifFalse: [ self halt ].

	" do: [ :w | w stop ]."

	free := workers select: #isFree.
	free size - taskQueue size <= 0
		ifTrue: [ self spawnWorkerIfNeeded ]