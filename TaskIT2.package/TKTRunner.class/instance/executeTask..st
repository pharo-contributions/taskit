running
executeTask: aTask

	[ aTask value ]
		on: Error
		do: [ :error | exceptionHandler handleException: error ]