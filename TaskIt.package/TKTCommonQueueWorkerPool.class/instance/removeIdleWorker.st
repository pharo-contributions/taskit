removing
removeIdleWorker
	| removing |
	self halt. 
	removing := (workers reject: #isRunning) first.
	removing stop.
	workers remove: removing