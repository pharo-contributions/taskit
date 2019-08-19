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
		'maxBackeds',
		'pool'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #accessing }
TKTArchetypedQueueController >> archetype [
	^ archetype
]

{ #category : #initialization }
TKTArchetypedQueueController >> archetype: anArchetype pool: aPool backends: anAmount [
	archetype := anArchetype.
	pool := aPool.
	maxBackeds := anAmount.
	deploy := archetype deploy.

]

{ #category : #service }
TKTArchetypedQueueController >> cleanUpImageToStart [
	queue removeAll. 
	backends removeAll. 

	
]

{ #category : #accessing }
TKTArchetypedQueueController >> deploy [
	^ deploy
		ifNil: [ deploy := archetype deploy ]
]

{ #category : #health }
TKTArchetypedQueueController >> ensureEnoughBackends [
	(backends reject: #isAlive) do: #stopAndDelete.
	backends removeAll: (backends reject: #isAlive).
	backends size < maxBackeds
		ifTrue: [ self spawnNewBackend ]
]

{ #category : #health }
TKTArchetypedQueueController >> ensureIsWorking [
	queue isEmpty
		ifTrue: [ ^ self ].
	backends do: [ :b | b ensureIsAlive: pool ]
]

{ #category : #accessing }
TKTArchetypedQueueController >> findBackendById: aHash [
	^ backends detect: [ :b | b hash = aHash ]
]

{ #category : #initialization }
TKTArchetypedQueueController >> initialize [
	super initialize.
	queue := AtomicSharedQueue new.
	backends := OrderedCollection new
]

{ #category : #testing }
TKTArchetypedQueueController >> managesBackendId: aHash [
	^ backends anySatisfy: [ :b | b hash = aHash ]
]

{ #category : #accessing }
TKTArchetypedQueueController >> maxBackends [
	^ maxBackeds ifNil: [ maxBackeds := 1 ]
]

{ #category : #notifications }
TKTArchetypedQueueController >> noteRemoteWorkerAt: anUrl forBackendHashed: aHash [
	backends
		select: [ :b | b hash = aHash ]
		thenDo: [ :b | b setUrl: anUrl ]
]

{ #category : #notifications }
TKTArchetypedQueueController >> noteTaskHasBeenScheduled [
	self ensureEnoughBackends.
	backends do: [ :b | b noteTaskScheduled ]
]

{ #category : #notifications }
TKTArchetypedQueueController >> noteTaskHasFinished: aTaskExecution [
	backends do: [ :b | b noteTaskHasFinished: aTaskExecution ]
]

{ #category : #service }
TKTArchetypedQueueController >> requestTaskOrNilForBackend: aHash [
	| backend taskExecution | 
	backend := self findBackendById: aHash. 
	taskExecution := queue nextIfNone: [ ^ nil ].
	backend isAlive ifFalse: [ ^ nil ].
	backend assignTask: taskExecution.
	taskExecution backend: backend.
	taskExecution doExecuteTask.  " informs the task to the backend "
	
]

{ #category : #schedulling }
TKTArchetypedQueueController >> scheduleTaskExecution: aTaskExecution [
	pool registerTaskExecution: aTaskExecution.
	queue nextPut: aTaskExecution.
	self noteTaskHasBeenScheduled
]

{ #category : #schedulling }
TKTArchetypedQueueController >> scheduleTaskExecutionNotDeployable: aTaskExecution [
	pool registerNotDeployableTaskExecution: aTaskExecution.
	self noteTaskHasBeenScheduled
]

{ #category : #service }
TKTArchetypedQueueController >> spawnNewBackend [
	| backend |
	backend := TKTForkedBackend new.
	backends add: backend.
	backend defaultSerializerSelector: #xstoned.
	self deploy clone configureBackend: backend.
	backend startWith: pool
]

{ #category : #service }
TKTArchetypedQueueController >> stop [
	backends do: #stop
]

{ #category : #service }
TKTArchetypedQueueController >> stopAndDelete [
	backends do: #stopAndDelete
]
