running
testActorMessageSendSchedulesIntoMailBox
	actor send: (Message selector: #yourself arguments: {}).
	self assert: actor mailbox size equals: 1