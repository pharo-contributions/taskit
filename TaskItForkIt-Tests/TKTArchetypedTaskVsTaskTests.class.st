Class {
	#name : #TKTArchetypedTaskVsTaskTests,
	#superclass : #TestCase,
	#category : #'TaskItForkIt-Tests'
}

{ #category : #tests }
TKTArchetypedTaskVsTaskTests >> futureArchetypedTask: task [
	^ #futureArchetypedTask:
]

{ #category : #tests }
TKTArchetypedTaskVsTaskTests >> privateFuture: aTask [
	^ #privateFuture:
]

{ #category : #tests }
TKTArchetypedTaskVsTaskTests >> testArchetypedTaskBuildsOnRunnerWithPrivateFutureMessage [
	self
		assert: (TKTArchetypedTask new future: self)
		equals: #futureArchetypedTask:
]

{ #category : #tests }
TKTArchetypedTaskVsTaskTests >> testCanBuildTaskFromCleanBlockClosure [
	| clean closure |
	closure := [  ].
	clean := closure asArchetypedTaskOn: TKTArchetype pharo80.
	self assert: closure equals: clean valuable
]

{ #category : #tests }
TKTArchetypedTaskVsTaskTests >> testCanBuildTaskFromCleanMessageSend [
	| clean msg |
	msg := MessageSend receiver: self selector: #yourself.
	clean := msg asArchetypedTaskOn: TKTArchetype pharo80.
	self assert: msg equals: clean valuable
]

{ #category : #tests }
TKTArchetypedTaskVsTaskTests >> testCannotBuildTaskFromNonCleanBlockClosure [
	| clean closure |
	closure := [ self ].
	self
		should: [ clean := closure asArchetypedTaskOn: TKTArchetype pharo80 ]
		raise: Error
]

{ #category : #tests }
TKTArchetypedTaskVsTaskTests >> testGenericTaskBuildsOnRunnerWithPrivateFutureMessage [
	self assert: (TKTGenericTask new future: self) equals: #privateFuture:
]

{ #category : #tests }
TKTArchetypedTaskVsTaskTests >> testGenericTaskResolvesThisImageAsArchetype [
	self assert: [  ] asTask archetype equals: TKTArchetype thisImage
]

{ #category : #tests }
TKTArchetypedTaskVsTaskTests >> testTaskitSchedulersDonotSupportArchetyping [
	| runners archetypedTask |
	runners := Set new.
	archetypedTask := [  ] asArchetypedTaskOn: TKTArchetype pharo80.
	TKTAbstractExecutor
		allSubclassesWithLevelDo: [ :c :l | runners add: c ]
		startingLevel: 1.
	self assert: runners size equals: 8.
	runners
		do: [ :r | self should: [ archetypedTask future: r ] raise: Error ]
]
