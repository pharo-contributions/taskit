tests-callbacks
testFutureFailureCallbackIsCalledIfFailureWasAlreadyDeployed

	| future got deployedError |
	future := TKTFuture new.
	future onFailureDo: [ :error | got := error ].
	
	deployedError := Error new.
	future deployFailure: deployedError.
	
	self assert: got equals: deployedError