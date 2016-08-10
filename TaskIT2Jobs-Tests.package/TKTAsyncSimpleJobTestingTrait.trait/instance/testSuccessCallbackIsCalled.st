tests
testSuccessCallbackIsCalled
	| varCB1 |
	self createRunningJobExecution.
	varCB1 := false.
	self jobExecution onSuccess: [ varCB1 := true ].
	20 milliSeconds wait.
	self assert: varCB1