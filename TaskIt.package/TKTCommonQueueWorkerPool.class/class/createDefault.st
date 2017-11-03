current
createDefault
	^ self new
		name: 'CommonPool-' , UUID new asString;
		poolMaxSize: 4;
		yourself