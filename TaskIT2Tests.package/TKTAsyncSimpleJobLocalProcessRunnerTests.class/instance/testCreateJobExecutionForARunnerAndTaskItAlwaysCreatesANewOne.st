tests
testCreateJobExecutionForARunnerAndTaskItAlwaysCreatesANewOne
	self deny: jobExecution  = (job createExecutionFor: taskExecution on: runner)