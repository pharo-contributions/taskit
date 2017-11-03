initialization
watchDog: aParameterPool
	aParameterPool failedTasks
		addAll: (aParameterPool workers reject: #isRunning thenCollect: #currentTaskExecution).
	(aParameterPool workers reject: #isRunning) do: #restart.
	aParameterPool manageWorkersBefore.
	aParameterPool manageWorkersAfter