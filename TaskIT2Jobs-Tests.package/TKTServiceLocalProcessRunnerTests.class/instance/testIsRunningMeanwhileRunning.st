as yet unclassified
testIsRunningMeanwhileRunning
	jobExecution := job runIn: runner.
	10 milliSeconds wait.
	self assert: jobExecution isRunning