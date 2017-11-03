instance creation
on: aPool
	^ self new
		initializeWith: aPool;
		start;
		yourself