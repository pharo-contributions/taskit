tests
testRetryEveryIsDoneIfLapseTimeIsBiggerThanTotalRetryTime

	self assert: (TKTRetry every: 1 minute for: 10 seconds) isDone