initialization
process: aProcess context: aContext
 	super
		process: aProcess
		context: aContext.
	
	exceptionProcessHolder := TKTRawProcessHolder for: aProcess
	
