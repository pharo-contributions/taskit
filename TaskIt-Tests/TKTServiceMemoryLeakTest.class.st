Class {
	#name : #TKTServiceMemoryLeakTest,
	#superclass : #TKTMemoryLeakTest,
	#category : #'TaskIt-Tests-Services'
}

{ #category : #'tests-worker' }
TKTServiceMemoryLeakTest >> testServiceInstancesAreCollectedAfterStartingAndStoppingService [

	self
		assertDontGrowNumberOf: TKTParameterizableService
		during: [ TKTParameterizableService new name: 'test'; start; stop  ]
]

{ #category : #'tests-worker' }
TKTServiceMemoryLeakTest >> testWorkerInstancesAreCollectedAfterStartingAndStoppingService [

	self
		assertDontGrowNumberOf: TKTWorker
		during: [ TKTParameterizableService new
				name: 'test';
				start;
				stop ]
]

{ #category : #'tests-worker' }
TKTServiceMemoryLeakTest >> testWorkerPoolInstancesAreCollectedAfterStartingAndStoppingService [

	self
		assertDontGrowNumberOf: TKTWorkerPool
		during: [ TKTParameterizableService new name: 'test'; start; stop  ]
]

{ #category : #'tests-worker' }
TKTServiceMemoryLeakTest >> testWorkerProcessInstancesAreCollectedAfterStartingAndStoppingService [

	self
		assertDontGrowNumberOf: TKTWorkerProcess
		during: [ TKTParameterizableService new name: 'test'; start; stop  ]
]
