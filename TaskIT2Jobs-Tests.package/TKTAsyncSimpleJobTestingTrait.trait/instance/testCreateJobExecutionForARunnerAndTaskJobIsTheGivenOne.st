tests
testCreateJobExecutionForARunnerAndTaskJobIsTheGivenOne
	self createPausedJobExecution.
	self assert: self job equals: self jobExecution job