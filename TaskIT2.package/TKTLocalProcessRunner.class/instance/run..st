running
run: aTaskExecution
	process
		ifNil: [ 
			process := self createProcessFor: aTaskExecution.
			process run ]
		ifNotNil: [ self error: 'Runner is already running' ]