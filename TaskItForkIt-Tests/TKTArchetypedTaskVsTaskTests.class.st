Class {
	#name : #TKTArchetypedTaskVsTaskTests,
	#superclass : #TKTForkItArchetypedTest,
	#category : #'TaskItForkIt-Tests'
}

{ #category : #tests }
TKTArchetypedTaskVsTaskTests >> testCanBuildTaskFromCleanBlockClosure [
	| clean closure |
	closure := [  ].
	clean := closure asArchetypedTaskOn: archetype.
	self assert: closure equals: clean valuable
]

{ #category : #tests }
TKTArchetypedTaskVsTaskTests >> testCanBuildTaskFromCleanMessageSend [
	| clean msg |
	msg := MessageSend receiver: self selector: #yourself.
	clean := msg asArchetypedTaskOn: archetype.
	self assert: msg equals: clean valuable
]

{ #category : #tests }
TKTArchetypedTaskVsTaskTests >> testCannotBuildTaskFromNonCleanBlockClosure [
	| closure |
	closure := [ self ].
	self
		should: [ closure asArchetypedTaskOn: archetype ]
		raise: Error
]

{ #category : #tests }
TKTArchetypedTaskVsTaskTests >> testTaskitSchedulersDonotSupportArchetyping [
	| runners archetypedTask |
	runners := Set new.
	archetypedTask := [  ] asArchetypedTaskOn: archetype.
	TKTAbstractExecutor
		allSubclassesWithLevelDo: [ :c :l | runners add: c ]
		startingLevel: 1.
	self assert: runners size equals: 8.
	runners
		do: [ :r | self should: [ archetypedTask future: r ] raise: Error ]
]
