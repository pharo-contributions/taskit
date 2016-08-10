tests
testCreateJobExecutionForARunnerAndTaskItAlwaysCreatesANewOne
	self createPausedJobExecution.
	self deny: self jobExecution = (self job createExecutionFor: self taskExecution on: self runner)