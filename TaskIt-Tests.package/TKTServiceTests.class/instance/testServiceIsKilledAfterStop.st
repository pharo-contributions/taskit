tests
testServiceIsKilledAfterStop

	service := TKTParameterizableService new.
	service name: 'test service'.
	service start.
	(service stop) waitForCompletion: 2 second.
	
	self deny: service isRunning.