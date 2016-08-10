accessing
valueTimeout: aTimeout
	
	timeoutMicroseconds := aTimeout.
	self waitForCompletion: aTimeout.
	^ result valueForFuture: self