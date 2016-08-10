notices
noteFailure: anError
	self cleanupExecution.
	hasBeenDeployed := true.
	isSuccess := false.
	value := anError.
	self invoke: failureCallbacks.
	semaphore signal.