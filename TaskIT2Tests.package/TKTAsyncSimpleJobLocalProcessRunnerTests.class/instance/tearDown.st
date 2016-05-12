running
tearDown
	self logCr: 'about to cancel'.
	jobExecution ifNotNil: [ jobExecution cancel ]