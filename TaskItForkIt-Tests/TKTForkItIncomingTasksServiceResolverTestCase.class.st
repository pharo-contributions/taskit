Class {
	#name : #TKTForkItIncomingTasksServiceResolverTestCase,
	#superclass : #TestCase,
	#instVars : [
		'service',
		'informSuccessCalled',
		'informErrorCalled',
		'future',
		'value',
		'id',
		'serializer'
	],
	#category : #'TaskItForkIt-Tests'
}

{ #category : #success }
TKTForkItIncomingTasksServiceResolverTestCase >> informError: aValue id: aString serializer: aTKTStonSerializationStrategy [
	informErrorCalled := true.
	value := aValue.
	id := aString.
	serializer := aTKTStonSerializationStrategy
]

{ #category : #success }
TKTForkItIncomingTasksServiceResolverTestCase >> informSuccess: anInteger id: aString serializer: aTKTStonSerializationStrategy [ 
	informSuccessCalled := true. 
	value := anInteger. 
	id := aString.
	serializer := aTKTStonSerializationStrategy
]

{ #category : #stub }
TKTForkItIncomingTasksServiceResolverTestCase >> privateFuture: aTKTGenericTask [
	| execution |
	execution := aTKTGenericTask futureTaskExecutionFor: self.
	future := execution future.
	^ future.
]

{ #category : #stub }
TKTForkItIncomingTasksServiceResolverTestCase >> schedule: aBlockClosure [ 
	aBlockClosure value
]

{ #category : #running }
TKTForkItIncomingTasksServiceResolverTestCase >> setUp [
	super setUp.
	service := TKTForkItIncomingTasksService new.
	TKTSerializationStrategy default: self.
	service master: 'error' asZnUrl.
	service usePool: self.
	service useResolver: self.
	informSuccessCalled := false.
	informErrorCalled := false
]

{ #category : #running }
TKTForkItIncomingTasksServiceResolverTestCase >> tearDown [
	TKTSerializationStrategy default: nil
]

{ #category : #running }
TKTForkItIncomingTasksServiceResolverTestCase >> testResolverIsUsedForInformError [
	self deny: informErrorCalled.
	service
		task:
			{[  ] asTask.
			#id}
		serializer: TKTSerializationStrategy default.
	future deployFailure: 1.
	self assert: informErrorCalled.
	self assert: value equals: 1.
	self assert: id equals: #id.
	self
		assert: serializer selector
		equals: TKTSerializationStrategy default selector
]

{ #category : #running }
TKTForkItIncomingTasksServiceResolverTestCase >> testResolverIsUsedForInformSuccess [
	self deny: informSuccessCalled.
	service
		task:
			{[  ] asTask.
			#id}
		serializer: TKTSerializationStrategy default.
	future deploySuccess: 1.
	self assert: informSuccessCalled.
	self assert: value equals: 1.
	self assert: id equals: #id.
	self
		assert: serializer selector
		equals: TKTSerializationStrategy default selector
]

{ #category : #running }
TKTForkItIncomingTasksServiceResolverTestCase >> writeZnRequestFor: backendHash to: master [
	
]
