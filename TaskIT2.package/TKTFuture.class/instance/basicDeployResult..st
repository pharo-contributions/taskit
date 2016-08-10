deployment
basicDeployResult: aValue

	result := TKTFutureSuccess new value: aValue.
	resultCallbacks do: [ :each | each value: aValue ].
	valueSemaphore signal.