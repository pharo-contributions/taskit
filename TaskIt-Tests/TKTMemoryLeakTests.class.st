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
	
	self garbageCollectAndWait .
	
	before := aClass allInstances size.
	
	aBlock value.
	
	self garbageCollectAndWait .
	
	self assert: before equals: aClass allInstances size.
]
