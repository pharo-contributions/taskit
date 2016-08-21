as yet unclassified
testStopServiceStopsUnderlyingWorker

	| executed service |
	executed := 0.
	
	service := TKTParameterizableService new.
	service name: 'test'.
	service task: [ executed := executed + 1 ].
	service start.
	service stop.
	
	self deny: service worker isRunning