deployment
basicDeployResult: aValue

	self installFutureResult: (TKTFutureSuccess new value: aValue).
	resultCallbacks do: [ :each | each value: aValue ].
	valueSemaphore signal.