as yet unclassified
testServiceExecutesStartUpOnStart

	| started |
	started := false.
	service := TKTParameterizableService new.
	service name: 'test service'.
	service onSetUpDo: [ started := true ].
	service start.
	
	100 milliSeconds wait.
	
	self assert: started.