tests
testSuccessCallbackReceivesValue
	| varCB1 |
	jobExecution := job runIn: runner.
	jobExecution onSuccess: [ :val | varCB1 := val ].
	20 milliSeconds wait.
	self assert: (varCB1 isKindOf: TKTDummyTestObject)