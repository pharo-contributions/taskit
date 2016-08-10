as yet unclassified
testConfigureRuntimeFailureIsTransmitedToTaskExcution
	jobExecution := job runIn: runner withArguments: {Object}.
	jobExecution onFailure: callbackOnFailure.
	self assert: jobExecution taskExecution onFailure equals: callbackOnFailure