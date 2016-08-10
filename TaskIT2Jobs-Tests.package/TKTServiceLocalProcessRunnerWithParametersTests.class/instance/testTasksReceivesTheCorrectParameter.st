as yet unclassified
testTasksReceivesTheCorrectParameter
	jobExecution := job runIn: runner withArguments: {Object}.
	10 milliSeconds wait.
	self assert: receiver parameter equals: Object