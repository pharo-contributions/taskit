tests
testStackStartingAt
	| process here contextHolder stack |
	process := self newRawProcess.
	
	here := thisContext.
	contextHolder := process masterProcessHolder findContextHolderSuchThat: [ :holder |
		holder originalContext == here ].
	stack := process masterProcessHolder stackStartingAt: contextHolder.
	
	self assert: stack first == here