evaluating
createExecutionFor: aTaskExecution on: aRunner
	| jobExecution |
	jobExecution := TKTAsyncExecution new
		taskExecution: aTaskExecution for: self at: aRunner;
		yourself.
	aTaskExecution
		onSuccess: (MessageSend receiver: jobExecution selector: #noteSuccess:);
		onFailure: (MessageSend receiver: jobExecution selector: #noteFailure:).
	^ jobExecution