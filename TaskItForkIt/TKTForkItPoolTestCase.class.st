Class {
	#name : #TKTForkItPoolTestCase,
	#superclass : #TestCase,
	#instVars : [
		'pool'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #running }
TKTForkItPoolTestCase >> runCaseManaged [
	^ self runCase
]

{ #category : #running }
TKTForkItPoolTestCase >> setUp [
	super setUp.
	pool := TKTArchetypeAwarePool createDefault.

]

{ #category : #running }
TKTForkItPoolTestCase >> tearDown [
	super tearDown.
	pool stop.
	"(TKTSystem rm
		option: '-rf';
		argument: ('pharo-local' asFileReference / #forking) fullName;
		future) synchronizeTimeout: 5 seconds"
]

{ #category : #running }
TKTForkItPoolTestCase >> testDefaultTaskIsScheduledInSuperClassQueue [
	self assert: (pool taskQueueSize: TKTArchetype thisImage) equals: 0.
	pool schedule: [  ] asTask.
	self assert: (pool taskQueueSize: TKTArchetype thisImage) equals: 1
]

{ #category : #running }
TKTForkItPoolTestCase >> testRemoteWorkerHasAnInstanceOfForkItService [
	| future |

	future := ((MessageSend
		receiver: TKTForkItIncomingTasksService
		selector: #allInstancesSize)
		asArchetypedTaskOn: TKTArchetype pharo70) future: pool.
		
	
	self assert: (future synchronizeTimeout: 2 minutes) equals: 1.
	self
		assert: TKTForkItIncomingTasksService allInstances size
		equals: 0
]

{ #category : #running }
TKTForkItPoolTestCase >> testRemoteWorkerIsReusedOnManyCallsAnInstanceOfForkItService [
	| future future2 future3 slot |
	future := pool
		future:
			((MessageSend receiver: TKTForkItIncomingTasksService selector: #allInstancesSize)
				asArchetypedTaskOn: TKTArchetype pharo70).
	future2 := pool
		future:
			((MessageSend receiver: TKTForkItIncomingTasksService selector: #allInstancesSize)
				asArchetypedTaskOn: TKTArchetype pharo70).
	future synchronizeTimeout: 5 minutes.
	future3 := pool
		future:
			((MessageSend receiver: TKTForkItIncomingTasksService selector: #allInstancesSize)
				asArchetypedTaskOn: TKTArchetype pharo70).
	{future.
	future2.
	future3}
		do: [ :f | self assert: (f synchronizeTimeout: 5 minutes) equals: 1 ].
	self assert: TKTForkItIncomingTasksService allInstances size equals: 0.
	slot := future class slotNamed: #runner.
	self assert: (slot read: future) equals: (slot read: future2).
	self assert: (slot read: future2) equals: (slot read: future3)
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
