running
testActorMessageSendSchedulesReturnsAFuture
	| future |
	future := actor send: (Message selector: #yourself arguments: {}).
	self assert: (future isKindOf: TKTFuture)