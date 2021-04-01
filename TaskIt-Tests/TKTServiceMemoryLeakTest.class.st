Class {
	#name : #TKTServiceMemoryLeakTest,
	#superclass : #TKTMemoryLeakTest,
	#category : #'TaskIt-Tests-Services'
}

{ #category : #running }
TKTServiceMemoryLeakTest >> startAndStopService [

	| service |
	service := TKTMockService new.
	service start.
	service stop waitForCompletion: 1 second.

]

{ #category : #tests }
TKTServiceMemoryLeakTest >> testServiceInstancesAreCollectedAfterStartingAndStoppingService [

	self
		assertDontGrowNumberOf: TKTParameterizableService
		during: [ self startAndStopService ]
]

{ #category : #tests }
TKTServiceMemoryLeakTest >> testWorkerInstancesAreCollectedAfterStartingAndStoppingService [

	self
		assertDontGrowNumberOf: TKTWorker
		during: [ self startAndStopService ]
]

{ #category : #tests }
TKTServiceMemoryLeakTest >> testWorkerPoolInstancesAreCollectedAfterStartingAndStoppingService [

	self
		assertDontGrowNumberOf: TKTWorkerPool
		during: [ self startAndStopService ]
]

{ #category : #tests }
TKTServiceMemoryLeakTest >> testWorkerProcessInstancesAreCollectedAfterStartingAndStoppingService [

	self
		assertDontGrowNumberOf: TKTWorkerProcess
		during: [ self startAndStopService ]
]
