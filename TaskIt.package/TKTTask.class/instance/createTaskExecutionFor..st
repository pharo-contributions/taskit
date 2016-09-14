executing
createTaskExecutionFor: aRunner
	| execution |
	execution := TKTFutureExecution new.
	execution runner: aRunner.
	execution task: self.
	^ execution