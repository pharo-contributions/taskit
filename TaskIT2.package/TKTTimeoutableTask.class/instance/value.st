executing
value

	| finished taskProcess |
	[
	finished := false.
	taskProcess := Processor activeProcess.	
	TKTProcessProvider createProcessDoing: [ timeout wait.
		finished ifFalse: [ | activeContext timeoutContext |
			activeContext := taskProcess suspendedContext.
			timeoutContext := [ TKTTimeoutException signal ] asContext.
			timeoutContext privSender: activeContext.
			taskProcess suspendedContext: timeoutContext ] ] named: 'TimeoutProcess(task=', self asString, ')'.	
	super value ] ensure: [ finished := true ]