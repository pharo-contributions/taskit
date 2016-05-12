convenience
createPausedJobExecution
	taskExecution := job createTaskExecution.
	jobExecution := job createExecutionFor: taskExecution on: runner