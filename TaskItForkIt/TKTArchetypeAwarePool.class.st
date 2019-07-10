"
An archetype aware pool is a simple dispatcher of tasks .It spawn a workerpool per archetype. The classical taskit is extended to make it tasks to use TKTArchetype thisImage. 
"
Class {
	#name : #TKTArchetypeAwarePool,
	#superclass : #Object,
	#instVars : [
		'remoteFutureRegistry',
		'pool',
		'archetypedBackends',
		'defaultSerializerSelector'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #creating }
TKTArchetypeAwarePool class >> createDefault [
	^ self new
		defaultSerializerSelector: #ston;
		yourself
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> allBackendsCollect: anArchetypedTask [
	| backendsFor |
	backendsFor := self backendsFor: anArchetypedTask archetype.
	^ backendsFor
		collect: [ :b | self futureArchetypedTask: anArchetypedTask backend: b ]
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> allBackendsDo: anArchetypedTask [
	| backendsFor |
	backendsFor := self backendsFor: anArchetypedTask archetype.
	backendsFor
		do: [ :b | self scheduleArchetypedTask: anArchetypedTask backend: b ]
]

{ #category : #accessing }
TKTArchetypeAwarePool >> amountOfTasksAt: aTKTArchetype [
	^ self remoteFutureRegistry amountOfTasksFor: aTKTArchetype
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> backendFor: anArchetype [
	^ archetypedBackends
		detect: [ :b | b respondsToArchetype: anArchetype ]
		ifNone: [ self spawnNewBackendFor: anArchetype ]
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> backendsFor: anArchetype [
	^ archetypedBackends
		select: [ :b | b respondsToArchetype: anArchetype ]
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> defaultSerializerSelector [
	^ defaultSerializerSelector
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> defaultSerializerSelector: aDefaultSerializerSelector [
	defaultSerializerSelector := aDefaultSerializerSelector
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> ensureIsWorking [
	archetypedBackends do: [ :b | b ensureIsAlive: remoteFutureRegistry ]
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> future: aTask [
	^ aTask asTask future: self
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> futureArchetypedTask: aTask [
	^ self
		futureArchetypedTask: aTask
		backend: (self backendFor: aTask archetype)
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> futureArchetypedTask: aTask backend: aBackend [
	| execution |
	self assert: (aBackend respondsToArchetype: aTask archetype).
	execution := aTask asTask futureTaskExecutionFor: self.
	execution backend: aBackend.
	self remoteFutureRegistry register: execution.
	pool scheduleTaskExecution: execution.
	^ execution future
]

{ #category : #testing }
TKTArchetypeAwarePool >> includesArchetype: aTKTArchetype [
	^ archetypedBackends includes: [ :be | be respondsToArchetype: aTKTArchetype ]
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> initialize [
	super initialize.
	pool := TKTCommonQueueWorkerPool createDefault.
	archetypedBackends := Set new.
	TKTConfiguration watchDog watch: self
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> isDebuggingCompatible [
	^ true
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> isLocalThreadRunner [
	^ false 
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> isUIRunner [
	^ false 
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> noteRemoteWorkerAt: anUrl forBackendHashed: aHash [
	(archetypedBackends detect: [ :be | be hash = aHash ]) setUrl: anUrl
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> privateFuture: aTask [
	^ pool privateFuture: aTask
]

{ #category : #scheduleing }
TKTArchetypeAwarePool >> privateSchedule: aTKTGenericTask [
	pool privateSchedule: aTKTGenericTask
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> remoteFutureRegistry [
	^ remoteFutureRegistry
		ifNil: [ remoteFutureRegistry := TKTOutgoingTasksService new.
			remoteFutureRegistry top: self.
			remoteFutureRegistry start.
			remoteFutureRegistry ]
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> schedule: aTask [
	aTask asTask schedule: self
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> schedule: aTask timeout: aTimeout [
	^ pool schedule: aTask timeout: aTimeout
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> scheduleArchetypedTask: aTask [
	^ self
		scheduleArchetypedTask: aTask
		backend: (self backendFor: aTask)
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> scheduleArchetypedTask: aTask backend: aBackend [
	| execution |
	self assert: (aBackend respondsToArchetype: aTask archetype).
	execution := aTask asTask futureTaskExecutionFor: self.
	execution backend: aBackend.
	self remoteFutureRegistry registerNotDeployable: execution.
	pool scheduleTaskExecution: execution
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> scheduleTaskExecution: aTaskExecution [
	^ pool scheduleTaskExecution: aTaskExecution
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> scheduleTimeout: timeout on: aTaskExecution [
	^ pool scheduleTimeout: timeout on: aTaskExecution
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> spawnNewBackendFor: anArchetype [
	| backend |
	self halt.
	backend := TKTForkedBackend new.
	backend defaultSerializerSelector: self defaultSerializerSelector.
	anArchetype configureBackend: backend. 
	backend archetype: anArchetype.
	archetypedBackends add: backend.
	
	backend startWith: self remoteFutureRegistry.
	
	
	^ backend
]

{ #category : #stop }
TKTArchetypeAwarePool >> stop [
	TKTConfiguration watchDog stopWatching: self.
	archetypedBackends do: #stop.
	pool ifNotNil: [ pool stop ].
	archetypedBackends removeAll.
	pool := nil
]

{ #category : #stop }
TKTArchetypeAwarePool >> stopAndDelete [
	TKTConfiguration watchDog stopWatching: self.
	archetypedBackends do: #stopAndDelete.
	pool ifNotNil: [ pool stop ].
	archetypedBackends removeAll.
	pool := nil
]

{ #category : #accessing }
TKTArchetypeAwarePool >> taskQueueSize: aTKTArchetype [
	^ pool taskQueueSize
]
