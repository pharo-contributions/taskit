tests
testHolderForContext
	| process contextHolder |
	process := self newRawProcess.
	
	contextHolder := process masterProcessHolder holderForContext: thisContext.
	self assert: contextHolder originalContext == thisContext