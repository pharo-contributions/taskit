as yet unclassified
testServiceExecutesStartUpOnStart

	| started |
	started := false.
	service := TKTParameterizableService new.
	service onSetUpDo: [ started := true ].
	service start.
	
	10 milliSeconds wait.
	
	self assert: started.