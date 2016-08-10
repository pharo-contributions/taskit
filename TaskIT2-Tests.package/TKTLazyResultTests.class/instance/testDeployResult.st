tests
testDeployResult
	| result value |
	result := TKTLazyResult new.
	value := Object new.
	self assert: result class = TKTLazyResult.
	result deployValue: value.
	self assert: result == value