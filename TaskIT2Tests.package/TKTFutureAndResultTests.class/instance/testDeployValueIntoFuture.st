tests
testDeployValueIntoFuture
	| future value |
	future := TKTFuture new.
	
	value := Object new.
	future deployValue: value.
	
	self assert: future isValueAvailable.
	self assert: future value = value.
	