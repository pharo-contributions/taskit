executing
executeTask: aTaskExecution
	[ self noteBusy.
	aTaskExecution value.
	self noteFree ]
		on: Error
		do: [ :error | self exceptionHandler handleException: error ]