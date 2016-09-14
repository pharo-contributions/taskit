executing
executeTask: aTask
self halt.
	[ aTask value ]
		on: Error
		do: [ :error | self exceptionHandler handleException: error ]