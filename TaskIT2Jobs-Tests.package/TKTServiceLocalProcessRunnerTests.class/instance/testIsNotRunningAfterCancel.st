as yet unclassified
testIsNotRunningAfterCancel
	jobExecution := job runIn: runner.
	10 milliSeconds wait.
	jobExecution cancel.
	10 milliSeconds wait.
	self deny: jobExecution isRunning