evaluating
valueWithArguments: aSequenceOfArguments on: aTaskExecution
	[ aTaskExecution announceValue: (self valueWithArguments: aSequenceOfArguments) ]
		on: Error
		do: [ :error | aTaskExecution announceException: error ]