executing
value

	| finished taskProcess |
	[
	finished := false.
	taskProcess := Processor activeProcess.	
	[ timeout wait.
		finished ifFalse: [ | activeContext timeoutContext |
			activeContext := taskProcess suspendedContext.
			timeoutContext := [ TKTTimeoutException signal ] asContext.
			timeoutContext privSender: activeContext.
			taskProcess suspendedContext: timeoutContext ] ] fork.
	
	super value ] ensure: [ finished := true ]