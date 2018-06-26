tests
testActorModelHastActirBehaviourSet
	| actor behaviour |
	behaviour := TKTActorBehaviour new.
	actor := behaviour actor.
	self assert: actor model equals: behaviour