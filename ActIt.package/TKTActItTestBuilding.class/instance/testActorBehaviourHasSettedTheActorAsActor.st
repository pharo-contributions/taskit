tests
testActorBehaviourHasSettedTheActorAsActor
	| actor behaviour |
	behaviour := TKTActorBehaviourTest new.
	actor := behaviour actor.
	self assert: behaviour actor equals: actor