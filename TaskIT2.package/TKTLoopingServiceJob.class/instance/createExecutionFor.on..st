evaluating
createExecutionFor: aTaskExecution on: aRunner
	^ TKTServiceJobExecution new
		taskExecution: aTaskExecution for: self at: aRunner;
		yourself