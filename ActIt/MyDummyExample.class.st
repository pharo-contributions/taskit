Class {
	#name : #MyDummyExample,
	#superclass : #Object,
	#traits : 'TKTActorBehaviour',
	#classTraits : 'TKTActorBehaviour classTrait',
	#instVars : [
		'state'
	],
	#category : #'ActIt-Example'
}

{ #category : #accessing }
MyDummyExample >> isStateNil [
	^ state isNil
]

{ #category : #accessing }
MyDummyExample >> state [
	^ state
]

{ #category : #accessing }
MyDummyExample >> state: aValue [
	state := aValue 
]
