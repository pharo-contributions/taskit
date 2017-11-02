accessing
watchDog
	failedTasks addAll: (workers reject: #isRunning thenCollect: #currentTask).
	(workers reject: #isRunning) do: #restart.
	self manageWorkersBefore.
	self manageWorkersAfter