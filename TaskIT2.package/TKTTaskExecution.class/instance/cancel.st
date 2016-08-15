evaluating
cancel

	| activeContext timeoutContext |
	activeContext := executionProcess suspendedContext.
	timeoutContext := [ TKTTimeoutException signal ] asContext.
	timeoutContext privSender: activeContext.
	executionProcess suspendedContext: timeoutContext