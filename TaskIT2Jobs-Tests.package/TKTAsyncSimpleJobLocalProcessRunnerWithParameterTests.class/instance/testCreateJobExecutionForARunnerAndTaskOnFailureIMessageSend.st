tests
testCreateJobExecutionForARunnerAndTaskOnFailureIMessageSend
	self createPausedJobExecution.
	self assert: (self taskExecution onFailure isKindOf: MessageSend)