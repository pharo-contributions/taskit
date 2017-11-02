initialization
initialize
	super initialize.
	workers := Set new.
	failedTasks := OrderedCollection new.
	taskQueue := AtomicSharedQueue new.
	poolWorker := TKTParameterizableService new
		step: [ self watchDog ];
		yourself.
	self name: 'Worker' , self identityHash asString