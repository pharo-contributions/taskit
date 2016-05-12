as yet unclassified
testRunTheTaskRunsAndInformsTheError
	runner
		run:
			((TKTSimpleTaskExecution task: task)
				onFailure: [ :val | executionFailed := val ];
				yourself).
	20 milliSeconds wait.
	self assert: (executionFailed isKindOf: Error)