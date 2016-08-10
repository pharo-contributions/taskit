as yet unclassified
setUp
	super setUp.
	job := TKTSynchronousSimpleJob forTask: (TKTTask receiver: TKTDummyTestObject new selector: #dummyMessage).
	runner := TKTSameProcessRunner new.
	taskExecution := job createTaskExecution.
	future := job createExecutionFor: taskExecution on: runner