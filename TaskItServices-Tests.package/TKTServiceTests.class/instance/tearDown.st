as yet unclassified
tearDown

	super tearDown.
	service isRunning ifTrue: [
		(service stop) waitForCompletion: 1 second ].