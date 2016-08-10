as yet unclassified
testConfigureRuntimeFailureIsTransmitedToTaskExcution
	jobExecution := job runIn: runner.
	jobExecution onFailure: callbackOnFailure.
	self assert: jobExecution taskExecution onFailure equals: callbackOnFailure