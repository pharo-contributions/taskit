"
An archetyped
"
Class {
	#name : #TKTArchetypedQueueController,
	#superclass : #Object,
	#instVars : [
		'queue',
		'archetype',
		'deploy',
		'backends',
		'registry',
		'maxBackeds'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #accessing }
TKTArchetypedQueueController >> archetype [
	^ archetype
]

{ #category : #schedulling }
TKTArchetypedQueueController >> archetype: anArchetype registry: aRegistry backends: anAmount [
	archetype := anArchetype.
	registry := aRegistry.
	maxBackeds := anAmount.
	deploy := archetype deploy.
]

{ #category : #schedulling }
TKTArchetypedQueueController >> cleanUpImageToStart [
	queue removeAll. 
	backends removeAll. 
	registry stop.

	
]

{ #category : #schedulling }
TKTArchetypedQueueController >> deploy [
	^ deploy
		ifNil: [ deploy := archetype deploy ]
]

{ #category : #schedulling }
TKTArchetypedQueueController >> ensureEnoughBackends [
	self maxBackends < queue size
		ifTrue: [ self spawnNewBackend ]
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
TKTArchetypedQueueController >> maxBackends [
	^ maxBackeds ifNil: [ maxBackeds := 1 ]
]

{ #category : #schedulling }
TKTArchetypedQueueController >> noteRemoteWorkerAt: anUrl forBackendHashed: aHash [
	backends
		select: [ :b | b hash = aHash ]
		thenDo: [ :b | b setUrl: anUrl ]
]

{ #category : #schedulling }
TKTArchetypedQueueController >> noteTaskHasBeenScheduled [
	self ensureEnoughBackends.
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
	queue nextPut: aTaskExecution.
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
	self deploy clone configureBackend: backend.
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
