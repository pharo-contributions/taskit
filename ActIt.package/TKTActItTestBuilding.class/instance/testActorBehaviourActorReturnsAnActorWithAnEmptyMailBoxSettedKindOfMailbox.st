tests
testActorBehaviourActorReturnsAnActorWithAnEmptyMailBoxSettedKindOfMailbox
	| actor |
	actor := TKTActorBehaviourTest new actor.
	self assert: (actor mailbox isKindOf: TKTMailBox).
	self assert: actor mailbox size equals: 0