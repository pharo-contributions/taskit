running
testActorMessageSendReceiverIsSetted
	actor send: (Message selector: #yourself arguments: {}).
	self assert: (actor mailbox next isKindOf: TKTFutureExecution)