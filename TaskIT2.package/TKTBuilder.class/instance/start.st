task building service
start
	self verifyForLoopingService.
	^ self privateRun
		onServiceFinalization: onServiceFinalization onFailure: onFailure;
		yourself