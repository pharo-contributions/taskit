actions
onFailure: aCallback
	failureCallbacks add: aCallback.
	self isError
		ifTrue: [ self invoke: {aCallback} ]