tests
testActorBehaviourHasSettedTheActorAsActor
	| actor behaviour |
	behaviour := TKTActorBehaviour new.
	actor := behaviour actor.
	self assert: behaviour actor equals: actor