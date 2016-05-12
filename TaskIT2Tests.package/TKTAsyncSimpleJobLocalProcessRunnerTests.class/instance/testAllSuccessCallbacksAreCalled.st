tests
testAllSuccessCallbacksAreCalled
	| varCB1 varCB2 |
	jobExecution := job runIn: runner.
	varCB1 := false.
	varCB2 := false.
	self halt. 
	jobExecution
		onSuccess: [ varCB1 := true ];
		onSuccess: [ varCB2 := true ].
	20 milliSeconds wait.
	self assert: varCB1.
	self assert: varCB2.

" IMPLEMENTARRRRRR "
	self assert: jobExecution isClean 