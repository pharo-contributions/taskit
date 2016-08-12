initialization
initialize

	super initialize.
	result := TKTFutureNotFinished new.
	runner := TKTCurrentTaskRunner value.

	valueSemaphore := Semaphore new.
"	timeoutMicroseconds := self class defaultTimeout.
	timeoutCallback := [ TKTTimeoutException signal ]."

	exceptionCallbacks := OrderedCollection new.
	resultCallbacks := OrderedCollection new.