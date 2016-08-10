deployment
deployInFuture: aFuture

	^ aFuture basicDeployResult: (self valueTimeout: aFuture timeout)