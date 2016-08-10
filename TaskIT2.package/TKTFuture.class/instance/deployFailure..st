deployment
deployFailure: aValue

	result := TKTFutureFailure new value: aValue.
	exceptionCallbacks do: [ :each | each value: aValue ].
	valueSemaphore signal.