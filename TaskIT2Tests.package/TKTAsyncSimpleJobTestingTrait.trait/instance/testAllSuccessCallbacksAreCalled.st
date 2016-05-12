tests
testAllSuccessCallbacksAreCalled
	| varCB1 varCB2 |
	self createRunningJobExecution.
	varCB1 := false.
	varCB2 := false.
	self jobExecution
		onSuccess: [ varCB1 := true ];
		onSuccess: [ varCB2 := true ].
	20 milliSeconds wait.
	self assert: varCB1.
	self assert: varCB2