initialization
initialize

	super initialize.
	size := 0.

	busyWorkers := Set new.
	freeWorkers := AtomicSharedQueue new.

	poolWorker := TKTWorker new.