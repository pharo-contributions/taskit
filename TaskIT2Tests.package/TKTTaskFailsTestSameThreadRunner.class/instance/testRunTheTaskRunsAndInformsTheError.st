as yet unclassified
testRunTheTaskRunsAndInformsTheError
	runner
		run:
			((TKTSimpleTaskExecution task: task)
				onFailure: [ :val | executionFailed := val ];
				yourself).
	self assert: (executionFailed isKindOf: Error)