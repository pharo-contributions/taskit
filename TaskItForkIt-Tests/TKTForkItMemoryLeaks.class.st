Class {
	#name : #TKTForkItMemoryLeaks,
	#superclass : #TKTForkItPoolTestCase,
	#category : #'TaskItForkIt-Tests'
}

{ #category : #tests }
TKTForkItMemoryLeaks class >> testParameters [
	^ ParametrizedTestMatrix new
		forSelector: #archetype
			addOptions:
			{TKTArchetype pharo80.
			TKTArchetype pharo70.
			TKTArchetype thisImage.
			TKTArchetype pharoCurrent};
		yourself
]

{ #category : #accessing }
TKTForkItMemoryLeaks >> archetype: anArchetype [
	archetype := anArchetype
]

{ #category : #accessing }
TKTForkItMemoryLeaks >> testRemoteWorkerHasAnInstanceOfForkItService [
	self
		trackInstancesOf: TKTArchetypeAwarePool
		during: [ super testRemoteWorkerHasAnInstanceOfForkItService ]
]

{ #category : #accessing }
TKTForkItMemoryLeaks >> testRemoteWorkerHasAnInstanceOfForkItServiceBlockVersion [
	self
		trackInstancesOf: TKTArchetypeAwarePool
		during: [ super testRemoteWorkerHasAnInstanceOfForkItServiceBlockVersion ]
]

{ #category : #accessing }
TKTForkItMemoryLeaks >> testRemoteWorkerIsReusedOnManyCallsAnInstanceOfForkItService [
	self
		trackInstancesOf: TKTArchetypeAwarePool
		during: [ super testRemoteWorkerIsReusedOnManyCallsAnInstanceOfForkItService ]
]

{ #category : #accessing }
TKTForkItMemoryLeaks >> testRemoteWorkerIsReusedOnManyCallsAnInstanceOfForkItServiceBlockVersion [
	self
		trackInstancesOf: TKTArchetypeAwarePool
		during: [ super testRemoteWorkerIsReusedOnManyCallsAnInstanceOfForkItServiceBlockVersion ]
]

{ #category : #accessing }
TKTForkItMemoryLeaks >> trackInstancesOf: aClass during: aBlock [

	| before |
	
	self garbageCollectAndWait .
	
	before := aClass allInstances size.
	
	aBlock value.
	
	self garbageCollectAndWait .
	
	self assert: before equals: aClass allInstances size.
]
