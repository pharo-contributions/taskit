accessing
scheduleTaskExecution: aTask

	self flag: #repeated.
	"Repeated with TKTQueueTaskScheduler"

	taskQueue nextPut: aTask