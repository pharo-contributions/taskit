start-stop
executeTask: aTaskExecution
	currentTaskExecution := aTaskExecution.
	super executeTask: aTaskExecution.
	currentTaskExecution := nil