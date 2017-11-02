accessing
watchDog
	failedTasks addAll: (workers reject: #isRunning thenCollect: #currentTaskExecution).
	(workers reject: #isRunning) do: #restart.
	self manageWorkersBefore.
	self manageWorkersAfter