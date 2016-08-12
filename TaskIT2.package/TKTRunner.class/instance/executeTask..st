running
executeTask: aTask

	TKTCurrentTaskRunner value: self.
	[ aTask value ]
		on: Error
		do: [ :error | exceptionHandler handleException: error ]