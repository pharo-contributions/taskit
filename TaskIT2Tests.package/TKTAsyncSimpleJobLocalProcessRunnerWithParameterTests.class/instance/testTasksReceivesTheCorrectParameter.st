tests
testTasksReceivesTheCorrectParameter
	jobExecution := self createRunningJobExecution.
	10 milliSeconds wait.
	self assert: receiver parameter equals: Object