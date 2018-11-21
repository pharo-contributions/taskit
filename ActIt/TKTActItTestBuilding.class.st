"
Tests 
"
Class {
	#name : #TKTActItTestBuilding,
	#superclass : #TestCase,
	#category : 'ActIt-Tests'
}

{ #category : #tests }
TKTActItTestBuilding >> testActorBehaviourActorReturnsAnActorWithAnEmptyMailBoxSettedKindOfMailbox [
	| actor |
	actor := TKTActorBehaviourTest new actor.
	self assert: (actor mailbox isKindOf: TKTMailBox).
	self assert: actor mailbox size equals: 0
]

{ #category : #tests }
TKTActItTestBuilding >> testActorBehaviourActorReturnsAnActorWithTheBehaviourSet [
	| actor |
	actor := TKTActorBehaviourTest new actor.
	self assert: (actor model isKindOf: TKTActorBehaviourTest).
	
]

{ #category : #tests }
TKTActItTestBuilding >> testActorBehaviourHasSettedTheActorAsActor [
	| actor behaviour |
	behaviour := TKTActorBehaviourTest new.
	actor := behaviour actor.
	self assert: behaviour actor equals: actor
]

{ #category : #tests }
TKTActItTestBuilding >> testActorModelHastActirBehaviourSet [
	| actor behaviour |
	behaviour := TKTActorBehaviourTest new.
	actor := behaviour actor.
	self assert: actor model equals: behaviour
]
