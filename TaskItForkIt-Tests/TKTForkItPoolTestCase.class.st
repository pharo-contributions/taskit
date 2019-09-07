Class {
	#name : #TKTForkItPoolTestCase,
	#superclass : #TKTForkItArchetypedTest,
	#instVars : [
		'pool',
		'serializer'
	],
	#category : #'TaskItForkIt-Tests'
}

{ #category : #'building suites' }
TKTForkItPoolTestCase class >> testParameters [
	^ super testParameters
		forSelector: #serializer addOptions: {#ston . #xstoned};
		yourself
]

{ #category : #running }
TKTForkItPoolTestCase >> runCaseManaged [
	^ self runCase
]

{ #category : #running }
TKTForkItPoolTestCase >> serializer: aSerializerSelector [
	serializer := aSerializerSelector
]

{ #category : #running }
TKTForkItPoolTestCase >> setUp [
	super setUp.
	pool := TKTArchetypeAwarePool createDefault.
	pool defaultSerializerSelector: serializer.
	
		
]

{ #category : #running }
TKTForkItPoolTestCase >> tearDown [
	super tearDown.
	pool stop.
	(TKTSystem rm
		option: '-rf';
		argument: ('pharo-local' asFileReference / #forking) fullName;
		future) synchronizeTimeout: 1 minute
]

{ #category : #running }
TKTForkItPoolTestCase >> testRemoteWorkerHasAnInstanceOfForkItService [
	| future initialSize |
	initialSize := TKTForkItIncomingTasksService allInstances size.
	future := ((MessageSend
		receiver: TKTForkItIncomingTasksService
		selector: #allInstancesSize) asArchetypedTaskOn: archetype)
		future: pool.
	self assert: (future synchronizeTimeout: 20 minutes) equals: 1.
	self
		assert: TKTForkItIncomingTasksService allInstances size
		equals: initialSize
]

{ #category : #running }
TKTForkItPoolTestCase >> testRemoteWorkerHasAnInstanceOfForkItServiceBlockVersion [
	| future initialSize |
	initialSize := TKTForkItIncomingTasksService allInstances size.
	future := ([ TKTForkItIncomingTasksService allInstancesSize ]
		asArchetypedTaskOn: archetype) future: pool.
	self assert: (future synchronizeTimeout: 20 minutes) equals: 1.
	self
		assert: TKTForkItIncomingTasksService allInstances size
		equals: initialSize
]

{ #category : #running }
TKTForkItPoolTestCase >> testRemoteWorkerIsReusedOnManyCallsAnInstanceOfForkItService [
	| future future2 future3 slot initialSize |
	initialSize := TKTForkItIncomingTasksService allInstances size.
	future := pool
		future:
			((MessageSend
				receiver: TKTForkItIncomingTasksService
				selector: #allInstancesSize) asArchetypedTaskOn: archetype).
	future2 := pool
		future:
			((MessageSend
				receiver: TKTForkItIncomingTasksService
				selector: #allInstancesSize) asArchetypedTaskOn: archetype).
	future synchronizeTimeout: 5 minutes.
	future3 := pool
		future:
			((MessageSend
				receiver: TKTForkItIncomingTasksService
				selector: #allInstancesSize) asArchetypedTaskOn: archetype).
	{future.
	future2.
	future3}
		do: [ :f | self assert: (f synchronizeTimeout: 5 minutes) equals: 1 ].
	self
		assert: TKTForkItIncomingTasksService allInstances size
		equals: initialSize.
	slot := future class slotNamed: #runner.
	self assert: (slot read: future) equals: (slot read: future2).
	self assert: (slot read: future2) equals: (slot read: future3)
]

{ #category : #running }
TKTForkItPoolTestCase >> testRemoteWorkerIsReusedOnManyCallsAnInstanceOfForkItServiceBlockVersion [
	| future future2 future3 slot initialSize |
	initialSize := TKTForkItIncomingTasksService allInstances size.
	future := ([ TKTForkItIncomingTasksService allInstancesSize ]
		asArchetypedTaskOn: archetype) future: pool.
	future2 := ([ TKTForkItIncomingTasksService allInstancesSize ]
		asArchetypedTaskOn: archetype) future: pool.
	future synchronizeTimeout: 5 minutes.
	future3 := ([ TKTForkItIncomingTasksService allInstancesSize ]
		asArchetypedTaskOn: archetype) future: pool.
	{future.
	future2.
	future3}
		do: [ :f | self assert: (f synchronizeTimeout: 5 minutes) equals: 1 ].
	self
		assert: TKTForkItIncomingTasksService allInstances size
		equals: initialSize.
	slot := future class slotNamed: #runner.
	self assert: (slot read: future) equals: (slot read: future2).
	self assert: (slot read: future2) equals: (slot read: future3)
]
