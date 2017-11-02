initialization
initialize
	super initialize.
	workers := Set new.
	failedTasks := OrderedCollection new.
	taskQueue := AtomicSharedQueue new.
	self name: 'Worker' , self identityHash asString