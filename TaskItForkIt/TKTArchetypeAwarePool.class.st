"
An archetype aware pool is a simple dispatcher of tasks .It spawn a workerpool per archetype. The classical taskit is extended to make it tasks to use TKTArchetype thisImage. 
"
Class {
	#name : #TKTArchetypeAwarePool,
	#superclass : #Object,
	#instVars : [
		'remoteFutureRegistry',
		'pool',
		'archetypedControllers',
		'defaultSerializerSelector'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #creating }
TKTArchetypeAwarePool class >> createDefault [
	^ self createDefaultWithPool: TKTCommonQueueWorkerPool createDefault
]

{ #category : #creating }
TKTArchetypeAwarePool class >> createDefaultWithPool: aPool [
	^ self new
		initializeWithPool: aPool;
		defaultSerializerSelector: #xstoned;
		yourself
]

{ #category : #accessing }
TKTArchetypeAwarePool >> amountOfTasksAt: aTKTArchetype [
	^ self remoteFutureRegistry amountOfTasksFor: aTKTArchetype
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> cleanUpImageToStart [
	pool ifNotNil: [ pool cleanUpImageToStart ].
	archetypedControllers
		ifNotNil: [ archetypedControllers do: #cleanUpImageToStart ]
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
	archetypedControllers
		do: [ :controller | controller ensureIsWorking ]
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> future: aTask [
	^ aTask asTask future: self
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> futureArchetypedTask: aTask [
	| execution |
	execution := aTask asTask futureTaskExecutionFor: self.
	(self privateArchetypedControllerFor: aTask archetype)
		scheduleTaskExecution: execution.
	^ execution future
]

{ #category : #testing }
TKTArchetypeAwarePool >> includesArchetype: aTKTArchetype [
	^ archetypedControllers
		includes: [ :controller | controller respondsToArchetype: aTKTArchetype ]
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> initializeWithPool: aPool [
	pool := aPool.
	archetypedControllers := Set new.
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
	archetypedControllers
		do:
			[ :controller | controller noteRemoteWorkerAt: anUrl forBackendHashed: aHash ]
]

{ #category : #accessing }
TKTArchetypeAwarePool >> pool: aTKTCommonQueueWorkerPool [ 
	pool := aTKTCommonQueueWorkerPool
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> privateArchetypedControllerFor: archetype [
	^ archetypedControllers
		detect: [ :a | a archetype = archetype ]
		ifNone: [ | new |
			new := TKTArchetypedQueueController new.
			archetypedControllers add: new.
			new
				archetype: archetype
					registry: self remoteFutureRegistry
					backends: 1;
				yourself.
			new ]
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
TKTArchetypeAwarePool >> requestTaskForBackend: aHash [
	^ (archetypedControllers
		detect: [ :controller | controller managesBackendId: aHash ])
		requestTaskOrNilForBackend: aHash
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
	| execution |
	execution := aTask asTask futureTaskExecutionFor: self.
	(self privateArchetypedControllerFor: aTask archetype)
		scheduleTaskExecutionNotDeployable: execution.
		
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> scheduleTaskExecution: aTaskExecution [
	^ pool scheduleTaskExecution: aTaskExecution
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> scheduleTimeout: timeout on: aTaskExecution [
	^ pool scheduleTimeout: timeout on: aTaskExecution
]

{ #category : #stop }
TKTArchetypeAwarePool >> stop [
	TKTConfiguration watchDog stopWatching: self.
	archetypedControllers do: #stop.
	remoteFutureRegistry ifNotNil: [ :r | r stop ].
	remoteFutureRegistry := nil.
	pool
		ifNotNil: [ pool = TKTConfiguration runner
				ifFalse: [ pool stop ] ].
	archetypedControllers removeAll.
	pool := nil
]

{ #category : #stop }
TKTArchetypeAwarePool >> stopAndDelete [
	TKTConfiguration watchDog stopWatching: self.
	archetypedControllers do: #stopAndDelete.
	remoteFutureRegistry ifNotNil: [ :r | r stop ].
	remoteFutureRegistry := nil.
	pool
		ifNotNil: [ pool = TKTConfiguration runner
				ifFalse: [ pool stop ] ].
	archetypedControllers removeAll.
	pool := nil
]

{ #category : #accessing }
TKTArchetypeAwarePool >> taskQueueSize: aTKTArchetype [
	^ pool taskQueueSize
]
