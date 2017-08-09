executing
futureTaskExecutionFor: aRunner
	| execution |

	execution := self executionClass new.
	execution runner: aRunner.
	execution task: self.
	^ execution