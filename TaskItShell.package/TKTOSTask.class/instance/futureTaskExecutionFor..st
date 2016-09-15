as yet unclassified
futureTaskExecutionFor: aRunner
	| execution |

	execution := TKTOSTaskExecution new.
	execution runner: aRunner.
	execution task: self.
	^ execution