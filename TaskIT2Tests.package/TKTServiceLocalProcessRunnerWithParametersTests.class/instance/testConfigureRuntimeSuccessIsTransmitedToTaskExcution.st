as yet unclassified
testConfigureRuntimeSuccessIsTransmitedToTaskExcution
	jobExecution := job runIn: runner withArguments: {Object}..
	jobExecution onServiceFinalization: callbackOnServiceFinalization.
	self assert: jobExecution taskExecution onLoopFinalization equals: callbackOnServiceFinalization