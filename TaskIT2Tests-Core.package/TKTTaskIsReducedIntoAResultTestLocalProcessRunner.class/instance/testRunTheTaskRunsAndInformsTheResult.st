as yet unclassified
testRunTheTaskRunsAndInformsTheResult
	runner
		run:
			((TKTSimpleTaskExecution task: task)
				onSuccess: [ :val | executionSucceed := val ];
				yourself).
	20 milliSeconds wait.
	self assert: executionSucceed equals: 4