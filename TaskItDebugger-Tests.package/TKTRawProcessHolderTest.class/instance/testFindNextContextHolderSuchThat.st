tests
testFindNextContextHolderSuchThat
	| process contextHolder |
	process := self newRawProcess.
	
	contextHolder := process masterProcessHolder findContextHolderSuchThat: [ :context | true ].
	self assert: contextHolder index = 1.
	
	contextHolder := process masterProcessHolder
		findNextContextHolder: contextHolder
		suchThat: [ :context | context index > 5 ].
	self assert: contextHolder index = 6.
	
	contextHolder := process masterProcessHolder
		findNextContextHolder: contextHolder
		suchThat: [ :context | context index > 5 ].
	self assert: contextHolder index = 7