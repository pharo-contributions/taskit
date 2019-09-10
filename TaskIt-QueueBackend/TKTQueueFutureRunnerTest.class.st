Class {
	#name : #TKTQueueFutureRunnerTest,
	#superclass : #TKTQueueAbstractTest,
	#instVars : [
		'slave',
		'master'
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
TKTQueueFutureRunnerTest >> testExecutingAnError [

	| aFuture result |
	aFuture := [ 1 / 0 ] asTask future: master.
	self should: [result := aFuture synchronizeTimeout: 5 seconds] raise: ZeroDivide.
	

]
