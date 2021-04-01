Class {
	#name : #TKTMemoryLeakTest,
	#superclass : #TKTTestCase,
	#category : #'TaskIt-Tests-Kernel'
}

{ #category : #private }
TKTMemoryLeakTest class >> isAbstract [

	^ self name = #TKTMemoryLeakTest
]

{ #category : #helpers }
TKTMemoryLeakTest >> assertDontGrowNumberOf: aClass during: aBlock [

	| before after |
	self garbageCollectAndWait.
	before := aClass allInstances size.

	aBlock value.

	self garbageCollectAndWait.
	after := aClass allInstances size.

	self 
		assert: after <= before
		description: ('Number of instances of {1} has grown from {2} to {3}' format: { aClass. before. after })
]
