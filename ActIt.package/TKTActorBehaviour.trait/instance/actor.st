accessing
actor
	^ self getOrCreateActor
		beWorkerActor;
		yourself