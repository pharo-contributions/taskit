accessing
localActor
	^ self getOrCreateActor 
		beLocalThreadActor;
		yourself