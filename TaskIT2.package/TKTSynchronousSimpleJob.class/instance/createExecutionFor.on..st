private
createExecutionFor: aTaskExecution on: aRunner
	| future |
	future := TKTFuture new.
	aTaskExecution
		onSuccess: (WeakMessageSend receiver: future selector: #deployValue:);
		onFailure: (WeakMessageSend receiver: future selector: #deployError:).
	future taskExecution: aTaskExecution for: self at: aRunner.
	^ future