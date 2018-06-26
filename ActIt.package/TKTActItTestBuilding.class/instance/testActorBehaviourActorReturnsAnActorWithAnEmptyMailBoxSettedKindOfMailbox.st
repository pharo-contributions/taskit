tests
testActorBehaviourActorReturnsAnActorWithAnEmptyMailBoxSettedKindOfMailbox
	| actor |
	actor := TKTActorBehaviour new actor.
	self assert: (actor mailbox isKindOf: TKTMailBox).
	self assert: actor mailbox size equals: 0