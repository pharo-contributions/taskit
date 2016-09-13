tests
testRetryEveryCannotRetryOverNumberOfLapsesIsInsideTotal

	| total lapse retry |
	total := 10 seconds.
	lapse := 1 second.
	retry := TKTRetry every: lapse for: total.
	
	total / lapse timesRepeat: [ retry := retry next ].
	self assert: retry isDone.
	self should: [ retry next ] raise: Error