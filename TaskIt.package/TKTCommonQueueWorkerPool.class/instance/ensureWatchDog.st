starting
ensureWatchDog
	(watchDog isNil or: [ watchDog isRunning not ])
		ifTrue: [ watchDog := TKTParameterizableService new
				step: [ self watchDogService ];
				yourself ]