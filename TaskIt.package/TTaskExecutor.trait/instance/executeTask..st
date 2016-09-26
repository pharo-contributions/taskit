executing
executeTask: aTask
	[ self noteBusy. aTask value. self noteFree ]
		on: Error
		do: [ :error | self exceptionHandler handleException: error ]