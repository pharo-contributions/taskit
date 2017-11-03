initialization
initialize
	super initialize.
	
	masterProcessHolder := (TKTRawProcessHolder for: Processor activeProcess) asWeakReference 