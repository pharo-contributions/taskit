Class {
	#name : #TKTForkItPoolResponseTestCase,
	#superclass : #TKTForkItArchetypedTest,
	#instVars : [
		'pool'
	],
	#category : #'TaskItForkIt-Tests'
}

{ #category : #running }
TKTForkItPoolResponseTestCase >> runCaseManaged [
	^ self runCase
]

{ #category : #running }
TKTForkItPoolResponseTestCase >> setUp [
	super setUp.
	pool := TKTArchetypeAwarePool createDefault.

]

{ #category : #running }
TKTForkItPoolResponseTestCase >> tearDown [
	super tearDown.
	pool stopAndDelete.
	
]

{ #category : #running }
TKTForkItPoolResponseTestCase >> testDefaultTaskIsScheduledInSuperClassQueue [
	self assert: (pool taskQueueSize: archetype) equals: 0.
	pool schedule: [  ] asTask.
	self assert: (pool taskQueueSize: archetype) equals: 1
]

{ #category : #running }
TKTForkItPoolResponseTestCase >> testSpecificArchetypeNonInstalledTriggersInstallation [
	self deny: (pool includesArchetype: archetype).
	pool schedule: ([  ] asArchetypedTaskOn: archetype).
	self assert: (pool amountOfTasksAt: archetype) equals: 1
]

{ #category : #running }
TKTForkItPoolResponseTestCase >> testSpecificArchetypeQueueOnInstalledArchetype [
	pool privateArchetypedControllerFor: archetype.
	self assert: (pool amountOfTasksAt: archetype) equals: 0.
	pool schedule: ([  ] asArchetypedTaskOn: archetype).
	self assert: (pool amountOfTasksAt: archetype) equals: 1
]
