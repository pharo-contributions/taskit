notices
noteSuccess: aValue
	self cleanupExecution.
	hasBeenDeployed := true.
	isSuccess := true.
	value := aValue.
	self invoke: successCallbacks.
	semaphore signal.