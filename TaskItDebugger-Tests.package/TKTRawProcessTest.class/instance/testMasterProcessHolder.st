tests
testMasterProcessHolder
	| process process2 |
	process := self newRawProcess.
	self assert: process masterProcessHolder notNil.
	self assert: process masterProcessHolder process == Processor activeProcess.
	
	process2 := self newRawProcess.
	process masterProcessHolder: (TKTRawProcessHolder for: process2).
	
	self assert: process masterProcessHolder process == process2.
	self assert: process2 masterProcessHolder process == Processor activeProcess