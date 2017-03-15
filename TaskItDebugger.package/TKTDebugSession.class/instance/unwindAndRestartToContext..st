evaluating
unwindAndRestartToContext: aContext
	|ctx holder |
	holder := exceptionProcessHolder holderForContext: aContext.
	holder ifNil: [ ^ super unwindAndRestartToContext: aContext ].
	
	ctx := holder popTo.
	ctx == aContext ifTrue: [ 
		"Only restart the process if the stack was unwind"
		holder process restartTop.
		self stepToFirstInterestingBytecodeIn: holder process ].
	
	self updateContextTo:  aContext