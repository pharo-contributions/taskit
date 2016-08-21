as yet unclassified
testServiceIsKilledAfterStop

	service := TKTParameterizableService new.
	service start.
	(service stop) waitForCompletion: 1 second.
	
	self deny: service isRunning.