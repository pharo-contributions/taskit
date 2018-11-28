Class {
	#name : #TKTMemoryLeakTests,
	#superclass : #TKTTestCase,
	#category : 'TaskIt-Tests-Kernel'
}

{ #category : #'tests-worker' }
TKTMemoryLeakTests >> testWorkerInstancesAreCollectedAfterStartingAndStoppingWorker [
	self trackInstancesOf: TKTWorker during: [ TKTWorker new start stop ]
]

{ #category : #'tests-worker' }
TKTMemoryLeakTests >> testWorkerInstancesAreCollectedAfterStartingAndStoppingWorkerPool [

	self
		trackInstancesOf: TKTWorker
		during: [ TKTWorkerPool new start stop ]
]

{ #category : #'tests-workerpool' }
TKTMemoryLeakTests >> testWorkerPoolInstancesAreCollectedAfterStartingAndStoppingWorker [

	self
		trackInstancesOf: TKTWorkerPool
		during: [ TKTWorkerPool new start stop ]
]

{ #category : #'tests-workerprocess' }
TKTMemoryLeakTests >> testWorkerProcessInstancesAreCollectedAfterStartingAndStoppingWorker [

	self
		trackInstancesOf: TKTWorkerProcess
		during: [ TKTWorker new start stop ]
]

{ #category : #'tests-workerprocess' }
TKTMemoryLeakTests >> testWorkerProcessInstancesAreCollectedAfterStartingAndStoppingWorkerPool [

	self
		trackInstancesOf: TKTWorkerProcess
		during: [ TKTWorkerPool new start stop ]
]

{ #category : #helpers }
TKTMemoryLeakTests >> trackInstancesOf: aClass during: aBlock [

	| before |
	
	7 timesRepeat: [
		Smalltalk garbageCollect.
		100 milliSeconds wait ].
	
	before := aClass allInstances size.
	
	aBlock value.
	
	7 timesRepeat: [
		Smalltalk garbageCollect.
		100 milliSeconds wait ].
	
	self assert: before equals: aClass allInstances size.
]
