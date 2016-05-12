tests
testAllSuccessCallbacksAreCalledWhenCallbackFails
	| varCB1 varCB2 |
	jobExecution := job runIn: runner withArguments: {Object}.
	varCB1 := false.
	varCB2 := false.
	jobExecution
		onSuccess: [ 1 / 0 ];
		onSuccess: [ varCB1 := true ];
		onSuccess: [ varCB2 := true ].
	20 milliSeconds wait.
	self assert: varCB1.
	self assert: varCB2