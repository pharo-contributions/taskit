execute
executeAutoSync
	self privateExecute.
	^ self startProcessResultFetcher.
	
	