starting
ensureWatchDog
	watchDog
		ifNil: [ watchDog := TKTParameterizableService new
				step: [ self watchDogService ];
				name: 'WatchDog-' , self name; start;
				yourself ].
	watchDog isRunning
		ifFalse: [ watchDog restart ]