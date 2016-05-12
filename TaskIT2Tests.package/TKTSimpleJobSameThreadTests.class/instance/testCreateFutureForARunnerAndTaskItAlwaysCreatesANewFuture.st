as yet unclassified
testCreateFutureForARunnerAndTaskItAlwaysCreatesANewFuture
	self deny: future = (job createExecutionFor: taskExecution on: runner)