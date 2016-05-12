tests
testAllSuccessCallbacksAreCalledEvenAfterExecution
	| varCB1 varCB2 executed |
	jobExecution := job runIn: runner.
	varCB1 := false.
	varCB2 := false.
	executed := false.
	jobExecution onSuccess: [ executed := true ].
	20 milliSeconds wait.
	self assert: executed.
	jobExecution
		onSuccess: [ varCB1 := true ];
		onSuccess: [ varCB2 := true ].
	self assert: varCB1.
	self assert: varCB2