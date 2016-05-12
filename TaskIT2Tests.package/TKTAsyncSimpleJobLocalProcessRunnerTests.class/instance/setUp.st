running
setUp
	super setUp.
	job := TKTAsynchronousSimpleJob forTask: (TKTTask receiver: TKTDummyTestObject new selector: #dummyMessage).
	runner := TKTLocalProcessRunner new.
	taskExecution := job createTaskExecution.
	jobExecution := job createExecutionFor: taskExecution on: runner