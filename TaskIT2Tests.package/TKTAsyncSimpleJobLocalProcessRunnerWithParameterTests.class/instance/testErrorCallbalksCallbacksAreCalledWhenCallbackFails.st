tests
testErrorCallbalksCallbacksAreCalledWhenCallbackFails
	| varCB1 |
	jobExecution := job runIn: runner withArguments: {Object}.
	jobExecution
		onSuccess: [ 1 / 0 ];
		onError: [ :errs | varCB1 := errs at: 1 ].
	20 milliSeconds wait.
	self assert: (varCB1 isKindOf: ZeroDivide)