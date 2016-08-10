as yet unclassified
testCreateFutureForARunnerAndTaskOnFailureIsWeakSend
	self assert: (taskExecution onFailure isKindOf: WeakMessageSend)