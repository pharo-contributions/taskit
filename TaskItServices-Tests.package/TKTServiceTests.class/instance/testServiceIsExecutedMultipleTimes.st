tests
testServiceIsExecutedMultipleTimes

	| executed service |
	executed := 0.
	
	service := TKTParameterizableService new.
	service name: 'test'.
	service task: [ executed := executed + 1 ].
	service start.
	
	10 milliSecond wait.
	service stop.
	
	self assert: executed > 1