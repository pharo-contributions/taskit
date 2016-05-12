running
run: aTaskExecution for: aJob at: aPriority
	process
		ifNil: [ 
			process := self createProcessFor: aTaskExecution.
			process annotate: #job with: aJob.
			process priority: aPriority.
			process run ]
		ifNotNil: [ self error: 'Runner is already running' ]