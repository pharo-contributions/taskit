"
This worker pool is a tipical worker pool extended to use remote processes of a specifica kind. 
"
Class {
	#name : #TKTArchetypedWorkerPool,
	#superclass : #TKTCommonQueueWorkerPool,
	#instVars : [
		'archetype',
		'backend',
		'futuresRegistry'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #'as yet unclassified' }
TKTArchetypedWorkerPool class >> createFor: anArchetype using: aFuturesRegistry [
	^ self new
		name: 'ArchetypedPool-' , UUID new asString;
		archetype: anArchetype;
		futuresRegistry: aFuturesRegistry;
		poolMaxSize: 2;
		yourself
]

{ #category : #accessing }
TKTArchetypedWorkerPool >> archetype: aTKTArchetype [ 
	archetype := aTKTArchetype
]

{ #category : #'as yet unclassified' }
TKTArchetypedWorkerPool >> future: aTask [
	| execution |
	execution := aTask asTask futureTaskExecutionFor: self.
	futuresRegistry register: execution.
	self scheduleTaskExecution: execution.
	^ execution future
]

{ #category : #'accessingas yet unclassified' }
TKTArchetypedWorkerPool >> futuresRegistry: aTKTArchetypeAwarePool [ 
	futuresRegistry := aTKTArchetypeAwarePool
]

{ #category : #accessing }
TKTArchetypedWorkerPool >> getOrCreateBackend [
	^ backend
		ifNil: [ backend := TKTForkedBackend new.
			backend archetype: archetype.
			backend startWith: futuresRegistry.
			backend ]
]

{ #category : #accessing }
TKTArchetypedWorkerPool >> noteRemoteWorkerAt: anUrl forBackendHashed: aHash [
	backend hash = aHash
		ifTrue: [ backend setUrl: anUrl ]
]

{ #category : #accessing }
TKTArchetypedWorkerPool >> privateNewWorker [
	| newWorker processWorker |
	processWorker := TKTForkedWorkerProcess new.
	processWorker backend: self getOrCreateBackend.
	newWorker := TKTWorker new
		name:
			self name , ' ArchetypeWorker #' , (self size + 1) asString , ' '
				, archetype name;
		taskQueue: taskQueue;
		privatePrepareProcess: processWorker;
		privateStart;
		yourself.
	workers add: newWorker.
	^ newWorker
]

{ #category : #'as yet unclassified' }
TKTArchetypedWorkerPool >> privateRemoveIdleWorkerIfNeeded [
	| removing free |
	free := self privateFreeWorkers.
	free size < ((taskQueue size + 1) * 2)
		ifTrue: [ ^ self ].
	removing := free anyOne.
	workers remove: removing.
	removing stop
]

{ #category : #'as yet unclassified' }
TKTArchetypedWorkerPool >> stop [
	super stop.
	backend ifNotNil: [backend stop]
]

{ #category : #'as yet unclassified' }
TKTArchetypedWorkerPool >> supportsArchetyping [
	^ true
]
