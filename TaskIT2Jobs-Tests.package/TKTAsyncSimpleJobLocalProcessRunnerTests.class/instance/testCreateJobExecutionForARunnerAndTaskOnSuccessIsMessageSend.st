tests
testCreateJobExecutionForARunnerAndTaskOnSuccessIsMessageSend
	self createPausedJobExecution.
	self assert: (self taskExecution onSuccess isKindOf: MessageSend)