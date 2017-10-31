initialization
initialize

	super initialize.
	result := TKTFutureNotFinished new.
	runner := TKTConfiguration runner.

	valueSemaphore := Semaphore new.

	exceptionCallbacks := OrderedCollection new.
	resultCallbacks := OrderedCollection new.