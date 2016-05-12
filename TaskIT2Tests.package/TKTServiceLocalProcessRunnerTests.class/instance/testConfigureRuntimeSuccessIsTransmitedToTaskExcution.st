as yet unclassified
testConfigureRuntimeSuccessIsTransmitedToTaskExcution
	jobExecution := job runIn: runner.
	jobExecution onServiceFinalization: callbackOnServiceFinalization.
	self assert: jobExecution taskExecution onLoopFinalization equals: callbackOnServiceFinalization