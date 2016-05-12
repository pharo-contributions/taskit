tests
testErrorCallbalksCallbacksAreCalledWhenCallbackFails
	| varCB1 |
	self createRunningJobExecution.
	self jobExecution
		onSuccess: [ 1 / 0 ];
		onError: [ :errs | varCB1 := errs at: 1 ].
	20 milliSeconds wait.
	self assert: (varCB1 isKindOf: ZeroDivide)