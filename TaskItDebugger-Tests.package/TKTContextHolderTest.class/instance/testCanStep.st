tests
testCanStep
	"#canStep only answers true when we have a live context."
	| semaphore process holder processContext process2 context |
	semaphore := Semaphore new.
	context := [
		"This second block is a small hack. #canStep currently
		disallows stepping within the bottom context as that could
		potentially lead to a locked up process / system because 
		that step could mean stepping over process termination.
		By introducing an extra block 'processContext' is not
		the bottom context and stepping becomes possible."
		[
			processContext := thisContext.
			process2 := self newRawProcess.
			semaphore signal.
			Processor activeProcess suspend.
			 ] value.  
			Processor activeProcess terminate.
		] asContext.
	process := (TKTRawProcess
		forContext: context
		priority: Processor activePriority)
			resume;
			yourself.
	semaphore wait.

	[
		self assert: process2 masterProcessHolder process == process.
		holder := process2 masterProcessHolder holderForContext: process2 masterProcessHolder stack first.
		self deny: holder canStep. "already returned from"
		holder := process2 masterProcessHolder holderForContext: processContext.
		self assert: holder canStep
	] ensure: [ process resume ]