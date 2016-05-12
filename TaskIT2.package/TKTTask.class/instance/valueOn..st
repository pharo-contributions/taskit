evaluating
valueOn: aTaskExecution
	[ aTaskExecution announceValue: self value ]
		on: Error
		do: [ :error | aTaskExecution announceException: error ]