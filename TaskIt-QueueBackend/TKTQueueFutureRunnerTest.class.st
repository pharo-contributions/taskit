Class {
	#name : #TKTQueueFutureRunnerTest,
	#superclass : #TKTQueueAbstractTest,
	#instVars : [
		'slave',
		'master',
		'slave2'
	],
	#category : #'TaskIt-QueueBackend-Tests'
}

{ #category : #running }
TKTQueueFutureRunnerTest >> setUp [
	
	super setUp.
	slave := self slaveForTest.
	slave start.
	
	master := self masterForTest.
	master start.
]

{ #category : #running }
TKTQueueFutureRunnerTest >> tearDown [

	slave ifNotNil:#stop.
	slave2 ifNotNil:#stop.	
	master ifNotNil: #stop.
	
	super setUp.
	
]

{ #category : #tests }
TKTQueueFutureRunnerTest >> testExecutingAFuture [

	| aFuture result |
	aFuture := [ 2 + 40 ] asTask future: master.
	result := aFuture synchronizeTimeout: 5 seconds.
	
	self assert: result equals: 42
]

{ #category : #tests }
TKTQueueFutureRunnerTest >> testExecutingAStreamFuture [

	| aStream result |
	aStream := master futureStream: [ 2 + 40 ] asTask.
	result := aStream waitForElements: 1 timeout: 5 seconds.
	
	self assert: result equals: {42} asOrderedCollection
]

{ #category : #tests }
TKTQueueFutureRunnerTest >> testExecutingAnError [

	| aFuture |
	aFuture := [ 1 / 0 ] asTask future: master.
	self should: [aFuture synchronizeTimeout: 5 seconds] raise: ZeroDivide.
]

{ #category : #tests }
TKTQueueFutureRunnerTest >> testTimeoutWaitingTwoElements [

	| aStream |
	aStream := master futureStream: [ 2 + 40 ] asTask.
	self should: [aStream waitForElements: 2 timeout: 2 seconds] raise: TKTTimeoutException.

]

{ #category : #tests }
TKTQueueFutureRunnerTest >> testWaitingTwoElements [

	| aStream result |
	
	slave2 := self slaveForTest.
	slave2 start.
	
	aStream := master futureStream: [ 2 + 40 ] asTask.
	result := aStream waitForElements: 2 timeout: 2 seconds.
	
	self assert: result equals: {42. 42} asOrderedCollection
]
