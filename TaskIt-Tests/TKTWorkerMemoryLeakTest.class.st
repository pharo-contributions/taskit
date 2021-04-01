Class {
	#name : #TKTWorkerMemoryLeakTest,
	#superclass : #TKTMemoryLeakTest,
	#category : #'TaskIt-Tests-Kernel'
}

{ #category : #'tests-worker' }
TKTWorkerMemoryLeakTest >> testWorkerInstancesAreCollectedAfterStartingAndStoppingWorker [
	self assertDontGrowNumberOf: TKTWorker during: [ TKTWorker new start stop ]
]

{ #category : #'tests-worker' }
TKTWorkerMemoryLeakTest >> testWorkerInstancesAreCollectedAfterStartingAndStoppingWorkerPool [

	self
		assertDontGrowNumberOf: TKTWorker
		during: [ TKTWorkerPool new start stop ]
]

{ #category : #'tests-workerpool' }
TKTWorkerMemoryLeakTest >> testWorkerPoolInstancesAreCollectedAfterStartingAndStoppingWorker [

	self
		assertDontGrowNumberOf: TKTWorkerPool
		during: [ TKTWorkerPool new start stop ]
]

{ #category : #'tests-workerprocess' }
TKTWorkerMemoryLeakTest >> testWorkerProcessInstancesAreCollectedAfterStartingAndStoppingWorker [

	self
		assertDontGrowNumberOf: TKTWorkerProcess
		during: [ TKTWorker new start stop ]
]

{ #category : #'tests-workerprocess' }
TKTWorkerMemoryLeakTest >> testWorkerProcessInstancesAreCollectedAfterStartingAndStoppingWorkerPool [

	self
		assertDontGrowNumberOf: TKTWorkerProcess
		during: [ TKTWorkerPool new start stop ]
]
