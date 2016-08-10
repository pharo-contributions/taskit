accessing
taskExecution: aTaskExecution for: aJob at: aRunner
	job := aJob.
	taskExecution := aTaskExecution.
	runner := aRunner.
	self registerFinalization.