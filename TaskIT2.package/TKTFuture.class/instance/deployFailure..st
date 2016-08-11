deployment
deployFailure: aValue

	self installFutureResult: (TKTFutureFailure new value: aValue).
	exceptionCallbacks do: [ :each | each value: aValue ].
	valueSemaphore signal.