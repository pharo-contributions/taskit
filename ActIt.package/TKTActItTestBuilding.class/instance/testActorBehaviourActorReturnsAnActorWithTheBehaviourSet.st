tests
testActorBehaviourActorReturnsAnActorWithTheBehaviourSet
	| actor |
	actor := TKTActorBehaviour new actor.
	self assert: (actor model isKindOf: TKTActorBehaviour).
	