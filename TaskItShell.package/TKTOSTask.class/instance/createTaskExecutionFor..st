as yet unclassified
createTaskExecutionFor: aRunner
	| execution |

	execution := TKTOSTaskExecution new.
	execution runner: aRunner.
	execution task: self.
	^ execution