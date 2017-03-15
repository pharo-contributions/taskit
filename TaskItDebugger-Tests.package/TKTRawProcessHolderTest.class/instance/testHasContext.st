tests
testHasContext
	| process |
	process := self newRawProcess.
	
	self assert: (process masterProcessHolder hasContext: thisContext).
	self deny: (process masterProcessHolder hasContext: nil)