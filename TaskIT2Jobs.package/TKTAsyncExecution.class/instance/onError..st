callbacks
onError: aCallback
	errorCallbacks add: aCallback.
	self invokeErrors: {aCallback}