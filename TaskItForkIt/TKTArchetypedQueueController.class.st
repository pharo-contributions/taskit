"
An archetyped
"
Class {
	#name : #TKTArchetypedQueueController,
	#superclass : #Object,
	#instVars : [
		'queue',
		'archetype',
		'backends',
		'registry'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #schedulling }
TKTArchetypedQueueController >> archetype: anArchetype registry: aRegistry backends: anAmount [
	archetype := anArchetype.
	registry := aRegistry.
	anAmount timesRepeat: [ self spawnNewBackend ]
]

{ #category : #schedulling }
TKTArchetypedQueueController >> findBackendById: aHash [
	^ backends detect: [ :b | b hash = aHash ]
]

{ #category : #schedulling }
TKTArchetypedQueueController >> initialize [
	super initialize.
	queue := AtomicSharedQueue new.
	backends := OrderedCollection new
]

{ #category : #schedulling }
TKTArchetypedQueueController >> managesBackendId: aHash [
	^ backends anySatisfy: [ :b | b hash = aHash ]
]

{ #category : #schedulling }
TKTArchetypedQueueController >> noteRemoteWorkerAt: anUrl forBackendHashed: aHash [
self halt.
	backends
		select: [ :b | b hash = aHash ]
		thenDo: [ :b | b setUrl: anUrl ]
]

{ #category : #schedulling }
TKTArchetypedQueueController >> noteTaskHasBeenScheduled [
	backends do: [ :b | b noteTaskScheduled ]
]

{ #category : #schedulling }
TKTArchetypedQueueController >> requestTaskOrNilForBackend: aHash [
	| backend taskExecution | 
	backend := self findBackendById: aHash. 
	taskExecution := queue nextIfNone: [ ^ nil ].
	backend isAlive ifFalse: [ ^ nil ].
	taskExecution backend: backend.
	taskExecution doExecuteTask.  " informs the task to the backend "
	
]

{ #category : #schedulling }
TKTArchetypedQueueController >> scheduleTaskExecution: aTaskExecution [
	registry register: aTaskExecution.
	self noteTaskHasBeenScheduled
]

{ #category : #schedulling }
TKTArchetypedQueueController >> scheduleTaskExecutionNotDeployable: aTaskExecution [
	registry registerNotDeployable: aTaskExecution.
	self noteTaskHasBeenScheduled
]

{ #category : #schedulling }
TKTArchetypedQueueController >> spawnNewBackend [
	| backend |
	backend := TKTForkedBackend new.
	backend defaultSerializerSelector: #xstoned.
	archetype configureBackend: backend.
	backends add: backend.
	backend startWith: registry
]

{ #category : #schedulling }
TKTArchetypedQueueController >> stop [
	backends do: #stop
]

{ #category : #schedulling }
TKTArchetypedQueueController >> stopAndDelete [
	backends do: #stopAndDelete
]
