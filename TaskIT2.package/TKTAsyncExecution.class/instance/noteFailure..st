notices
noteFailure: anError
	self halt.
	self uninstallTaskCallbalks.
	hasBeenDeployed := true.
	isSuccess := false.
	value := anError.
	self invoke: failureCallbacks