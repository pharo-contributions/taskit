actions
onServiceFinalization: aCallback
	taskExecution
		onLoopFinalization: [ aCallback value.
			semaphore signal ]