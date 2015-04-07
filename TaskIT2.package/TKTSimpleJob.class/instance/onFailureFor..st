configuration
onFailureFor: aTKTFuture
	^ [ :exception | aTKTFuture deployError: exception ]