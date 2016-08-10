evaluating
runIn: aRunner withArguments: anArrayOfArguments at: aPriority
	| jobExecution |
	jobExecution := self createExecutionFor: self createTaskExecution on: aRunner.
	jobExecution arguments: anArrayOfArguments.
	jobExecution priority: aPriority.
	jobExecution run.
	^ jobExecution