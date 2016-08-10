tests
testResultBecomes
	
	| future result |
	future := TKTFutureOLD new.
	result := future asResult.
	future deployValue: 'STRING'.
	self assert: result = 'STRING'.
	self assert: future asResult = 'STRING'.
	