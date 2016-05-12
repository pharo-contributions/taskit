tests
testResultBecomes
	
	| future result |
	future := TKTFuture new.
	result := future asResult.
	future deployValue: 'STRING'.
	self assert: result = 'STRING'.
	self assert: future asResult = 'STRING'.
	