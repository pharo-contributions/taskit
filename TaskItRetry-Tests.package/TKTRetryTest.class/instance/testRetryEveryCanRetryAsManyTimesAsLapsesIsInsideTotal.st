tests
testRetryEveryCanRetryAsManyTimesAsLapsesIsInsideTotal

	| total lapse retry |
	total := 10 seconds.
	lapse := 1 second.
	retry := TKTRetry every: lapse for: total.
	
	total / lapse timesRepeat: [ 
		self deny: retry isDone.
		retry := retry next ].