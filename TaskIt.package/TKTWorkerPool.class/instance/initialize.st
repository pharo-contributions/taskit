initialization
initialize

	super initialize.

	workers := Set new.
	freeWorkers := AtomicSharedQueue new.

	poolWorker := TKTWorker new.
	self name: 'Worker' , self identityHash asString.