starting
stop

	poolWorker stop.
	
	busyWorkers do: #stop.
	busyWorkers removeAll.
	
	[freeWorkers isEmpty]
		whileFalse: [ freeWorkers next stop ].
	
	size := 0