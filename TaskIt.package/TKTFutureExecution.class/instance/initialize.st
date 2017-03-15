initialization
initialize

	super initialize.
	future := TKTFuture new.
	
	Smalltalk
		at: #TKTDebugger
		ifPresent: [ :debugger |
			debugger isEnabled ifFalse: [ ^ self ].
			masterProcessHolder := (Smalltalk at: #TKTRawProcessHolder) for: Processor activeProcess ]