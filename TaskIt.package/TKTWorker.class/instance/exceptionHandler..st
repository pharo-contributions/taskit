accessing
exceptionHandler: aHandler
	exceptionHandler := aHandler.
	process ifNotNil: [ process exceptionHandler: aHandler ]