removing
removeIdleWorker
	| removing |
	removing := (workers select: #isFree) anyOne.
	removing stop.
	workers remove: removing