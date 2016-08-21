as yet unclassified
testCannotStartTwoServicesWithSameName

	| executed service newService |
	executed := 0.
	
	[service := TKTParameterizableService new.
	service name: 'test'.
	service task: [ 1 second wait ].
	service start.
	
	newService := TKTParameterizableService new.
	newService name: 'test'.
	newService task: [ 1 second wait ].
	self should: [service start] raise: Error ] ensure: [ 
		service stop.
		[newService stop] ifError: [  ]
	]