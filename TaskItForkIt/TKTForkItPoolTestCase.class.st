Class {
	#name : #TKTForkItPoolTestCase,
	#superclass : #TestCase,
	#instVars : [
		'pool'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #running }
TKTForkItPoolTestCase >> setUp [
	super setUp.
	pool := TKTArchetypeAwarePool createDefault.
	self timeLimit: 3 minutes.
]

{ #category : #running }
TKTForkItPoolTestCase >> tearDown [
	pool stop.
	(TKTSystem rm
		option: '-rf';
		argument: ('pharo-local' asFileReference / #forking) fullName;
		future) synchronizeTimeout: 5 seconds
]

{ #category : #running }
TKTForkItPoolTestCase >> testDefaultTaskIsScheduledInSuperClassQueue [
	self assert: (pool taskQueueSize: TKTArchetype thisImage) equals: 0.
	pool schedule: [  ] asTask.
	self assert: (pool taskQueueSize: TKTArchetype thisImage) equals: 1
]

{ #category : #running }
TKTForkItPoolTestCase >> testSpecificArchetypeNonInstalledTriggersInstallation [
	self deny: (pool includesArchetype: TKTArchetype pharo70).
	pool schedule: ([  ] asArchetypedTaskOn: TKTArchetype pharo70).
	self assert: (pool amountOfTasksAt: TKTArchetype pharo70) equals: 1
]

{ #category : #running }
TKTForkItPoolTestCase >> testSpecificArchetypeQueueOnInstalledArchetype [
	pool workerFor: TKTArchetype pharo70.
	self assert: (pool amountOfTasksAt: TKTArchetype pharo70) equals: 0.
	pool schedule: ([  ] asArchetypedTaskOn: TKTArchetype pharo70).
	self assert: (pool amountOfTasksAt: TKTArchetype pharo70) equals: 1
]
