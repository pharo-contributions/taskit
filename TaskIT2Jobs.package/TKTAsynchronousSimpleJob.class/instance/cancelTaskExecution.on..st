evaluating
cancelTaskExecution: aTaskExecution on: aRunner
	super cancelTaskExecution: aTaskExecution on: aRunner.
	aTaskExecution
		onSuccess: nil;
		onFailure: nil