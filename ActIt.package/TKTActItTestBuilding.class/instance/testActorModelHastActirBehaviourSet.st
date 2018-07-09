tests
testActorModelHastActirBehaviourSet
	| actor behaviour |
	behaviour := TKTActorBehaviourTest new.
	actor := behaviour actor.
	self assert: actor model equals: behaviour