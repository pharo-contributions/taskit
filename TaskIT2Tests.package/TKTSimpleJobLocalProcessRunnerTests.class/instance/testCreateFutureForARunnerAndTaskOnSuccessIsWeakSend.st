as yet unclassified
testCreateFutureForARunnerAndTaskOnSuccessIsWeakSend
	self assert: (taskExecution onSuccess isKindOf: WeakMessageSend)