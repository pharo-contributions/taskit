accessing
onSuccess: aCallback
	successCallbacks add: aCallback.
	self isSuccess
		ifTrue: [ self invoke: {aCallback} ]