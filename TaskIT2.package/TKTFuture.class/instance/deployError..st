deploy
deployError: anError
	error := anError.
	value := TKTInvalidFutureValue new.
	isDeployed := true.
	semaphore signal