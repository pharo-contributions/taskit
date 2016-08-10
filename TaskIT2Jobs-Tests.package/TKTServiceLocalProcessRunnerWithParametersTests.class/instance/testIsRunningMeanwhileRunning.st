as yet unclassified
testIsRunningMeanwhileRunning
	jobExecution := job runIn: runner withArguments: {Object}.. 
	10 milliSeconds wait.
	self assert: jobExecution isRunning