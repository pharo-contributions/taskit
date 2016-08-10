deploy
deployValue: aValue
	value := aValue.
	isDeployed := true.
	result ifNotNil: [ result deployValue: aValue ].
	semaphore signal