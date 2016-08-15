as yet unclassified
executeTask: aTask

	TKTCurrentTaskRunner value: self.
	[ aTask value ]
		on: Error
		do: [ :error | self exceptionHandler handleException: error ]