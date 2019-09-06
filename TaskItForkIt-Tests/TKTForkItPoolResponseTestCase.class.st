Class {
	#name : #TKTForkItPoolResponseTestCase,
	#superclass : #TestCase,
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
	self assert: (pool taskQueueSize: TKTArchetype thisImage) equals: 0.
	pool schedule: [  ] asTask.
	self assert: (pool taskQueueSize: TKTArchetype thisImage) equals: 1
]

{ #category : #running }
TKTForkItPoolResponseTestCase >> testSpecificArchetypeNonInstalledTriggersInstallation [
	self deny: (pool includesArchetype: TKTArchetype pharo70).
	pool schedule: ([  ] asArchetypedTaskOn: TKTArchetype pharo70).
	self assert: (pool amountOfTasksAt: TKTArchetype pharo70) equals: 1
]

{ #category : #running }
TKTForkItPoolResponseTestCase >> testSpecificArchetypeQueueOnInstalledArchetype [
	pool privateArchetypedControllerFor: TKTArchetype pharo70.
	self assert: (pool amountOfTasksAt: TKTArchetype pharo70) equals: 0.
	pool schedule: ([  ] asArchetypedTaskOn: TKTArchetype pharo70).
	self assert: (pool amountOfTasksAt: TKTArchetype pharo70) equals: 1
]
