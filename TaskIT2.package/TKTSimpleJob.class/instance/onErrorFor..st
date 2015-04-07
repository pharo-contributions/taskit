configuration
onErrorFor: aTKTFuture
	^ [ :exception | self manageException: exception relatedTo: aTKTFuture ]