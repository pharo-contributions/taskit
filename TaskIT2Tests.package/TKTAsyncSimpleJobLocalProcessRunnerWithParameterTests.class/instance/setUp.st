running
setUp
	super setUp.
	receiver := TKTDummyTestObject new.
	job := TKTAsynchronousSimpleJob forTask: (TKTTask receiver: receiver selector: #dummyMessageWithParameter:).
	runner := TKTLocalProcessRunner new.
	taskExecution := job createTaskExecution.
	jobExecution := job createExecutionFor: taskExecution on: runner