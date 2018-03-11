tests
testServiceExecutesTearDownOnStop

	| stopped |
	stopped := false.
	service := TKTParameterizableService new.
	service name: 'test service'.
	service onTearDownDo: [ stopped := true ].
	service start.
	(service stop) waitForCompletion: 2 second.

	self assert: stopped.