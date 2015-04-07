as yet unclassified
testProcessorIsIdleOn: aRunner
	self assert: aRunner isIdle.
	self reduceRunningIn: aRunner.
	self assert: aRunner isIdle.
	