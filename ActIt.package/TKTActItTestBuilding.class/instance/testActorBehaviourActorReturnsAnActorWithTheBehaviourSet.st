tests
testActorBehaviourActorReturnsAnActorWithTheBehaviourSet
	| actor |
	actor := TKTActorBehaviourTest new actor.
	self assert: (actor model isKindOf: TKTActorBehaviourTest).
	