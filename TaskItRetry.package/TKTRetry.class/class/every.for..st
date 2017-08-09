instance creation
every: lapseDuration for: totalDuration 
	
	^ self new
		lapseBetweenRetries: lapseDuration;
		nextRetryBlock: [ self every: lapseDuration for: (totalDuration - lapseDuration) ];
		doneBlock: [ lapseDuration > totalDuration ];
		yourself