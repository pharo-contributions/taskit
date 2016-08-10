as yet unclassified
testRunTheTaskRunsAndInformsTheResult
	runner
		run:
			((TKTSimpleTaskExecution task: task)
				onSuccess: [ :val | executionSucceed := val ];
				yourself).
	self assert: executionSucceed equals: 4