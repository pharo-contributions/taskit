tests
testSuccessCallbackIsCalled
	| varCB1 |
	jobExecution := job runIn: runner.
	varCB1 := false.
	jobExecution onSuccess: [ varCB1 := true ].
	20 milliSeconds wait.
	self assert: varCB1