as yet unclassified
tearDown
	jobExecution
		ifNotNil: [ 
			jobExecution isRunning
				ifTrue: [ jobExecution cancel ] ]