evaluating
cancel: aFuture
	super cancel: aFuture.
	aFuture deployValue: TKTCancelledFutureValue new