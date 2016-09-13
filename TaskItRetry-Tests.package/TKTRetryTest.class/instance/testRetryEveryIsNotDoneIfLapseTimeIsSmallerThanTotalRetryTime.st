tests
testRetryEveryIsNotDoneIfLapseTimeIsSmallerThanTotalRetryTime

	self deny: (TKTRetry every: 1 second for: 10 seconds) isDone