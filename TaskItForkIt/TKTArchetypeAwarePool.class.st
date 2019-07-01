"
An archetype aware pool is a simple dispatcher of tasks .It spawn a workerpool per archetype. The classical taskit is extended to make it tasks to use TKTArchetype thisImage. 
"
Class {
	#name : #TKTArchetypeAwarePool,
	#superclass : #Object,
	#instVars : [
		'remoteFutureRegistry',
		'pool',
		'archetypedBackends'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #creating }
TKTArchetypeAwarePool class >> createDefault [
	^ self new 
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

{ #category : #'deploying remote' }
TKTArchetypeAwarePool >> deployValue: aValue into: aTKTFuture [ 
	aValue isException 
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> future: aTask [
	^ aTask future: self
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> futureArchetypedTask: aTask [
	| execution |
	execution := aTask asTask futureTaskExecutionFor: self.
	execution backend: (self backendFor: aTask archetype).
	self remoteFutureRegistry register: execution.
	pool scheduleTaskExecution: execution.
	^ execution future
]

{ #category : #testing }
TKTArchetypeAwarePool >> includesArchetype: aTKTArchetype [
	^ archetypedBackends detect: [ :be | be respondsToArchetype: aTKTArchetype ]
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> initialize [
	super initialize.
	pool := TKTCommonQueueWorkerPool createDefault.
	archetypedBackends := Set new .
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
	pool schedule: aTask
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> schedule: aTask timeout: aTimeout [
	^ pool schedule: aTask timeout: aTimeout
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> scheduleArchetypedTask: aTask [
	| execution |
	execution := aTask asTask futureTaskExecutionFor: self.
	execution backend: (self backendFor: aTask archetype).
	self remoteFutureRegistry registerNotDeployable: execution.
	pool scheduleTaskExecution: execution.
	
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> scheduleTimeout: timeout on: aTaskExecution [
	^ pool scheduleTimeout: timeout on: aTaskExecution
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> spawnNewBackendFor: anArchetype [
	| backend |
	backend := TKTForkedBackend new.
	anArchetype configureBackend: backend. 
	backend archetype: anArchetype.
	archetypedBackends add: backend.
	
	backend startWith: self remoteFutureRegistry.
	
	
	^ backend
]

{ #category : #stop }
TKTArchetypeAwarePool >> stop [
	archetypedBackends do: #stop.
	pool ifNotNil: [ pool stop ].
	archetypedBackends removeAll.
	pool := nil
]

{ #category : #accessing }
TKTArchetypeAwarePool >> taskQueueSize: aTKTArchetype [
	^ pool taskQueueSize
]
