tests
testNewProcessIsPharoProcess
	self assert: ((TKTPharoProcessProvider new createProcessDoing: (MessageSend receiver: [ 1 + 1 ] selector: #value)) isKindOf: Process)