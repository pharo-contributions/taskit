"
An archetype aware pool is a simple dispatcher of tasks .It spawn a workerpool per archetype. The classical taskit is extended to make it tasks to use TKTArchetype thisImage. 
"
Class {
	#name : #TKTArchetypeAwarePool,
	#superclass : #Object,
	#instVars : [
		'inverseProxy',
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
	^ self inverseProxy amountOfTasksFor: aTKTArchetype
]

{ #category : #initialization }
TKTArchetypeAwarePool >> cleanUpImageToStart [
	TKTConfiguration watchDog stopWatching: self.
	pool
		ifNotNil: [ pool cleanUpImageToStart.
			pool = TKTConfiguration runner
				ifFalse: [ pool stop ] ].
	archetypedControllers
		ifNotNil: [ archetypedControllers do: #cleanUpImageToStart ].
	inverseProxy ifNotNil: [ :r | r cleanUpImageToStart ].
	archetypedControllers removeAll.
	pool := nil
]

{ #category : #accessing }
TKTArchetypeAwarePool >> defaultSerializerSelector [
	^ defaultSerializerSelector
]

{ #category : #accessing }
TKTArchetypeAwarePool >> defaultSerializerSelector: aDefaultSerializerSelector [
	defaultSerializerSelector := aDefaultSerializerSelector
]

{ #category : #service }
TKTArchetypeAwarePool >> ensureIsWorking [
	archetypedControllers
		do: [ :controller | controller ensureIsWorking ]
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> failTaskExecution: aTaskExecution [
	[ self error: aTaskExecution backend errorMessage ]
		on: Error
		do: [ :e | 
			inverseProxy
				deployFutureResult:
					{aTaskExecution id.
					e} ]
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> future: aTask [
	^ aTask asTask future: self
]

{ #category : #scheduling }
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

{ #category : #initialization }
TKTArchetypeAwarePool >> initializeWithPool: aPool [
	pool := aPool.
	archetypedControllers := Set new.
	TKTConfiguration watchDog watch: self
]

{ #category : #accessing }
TKTArchetypeAwarePool >> inverseProxy [
	^ inverseProxy
		ifNil: [ inverseProxy := TKTOutgoingTasksService new.
			inverseProxy top: self.
			inverseProxy start.
			inverseProxy ]
]

{ #category : #testing }
TKTArchetypeAwarePool >> isDebuggingCompatible [
	^ true
]

{ #category : #testing }
TKTArchetypeAwarePool >> isLocalThreadRunner [
	^ false 
]

{ #category : #testing }
TKTArchetypeAwarePool >> isUIRunner [
	^ false 
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> maxBackends [
	^ 1 
]

{ #category : #notifications }
TKTArchetypeAwarePool >> noteRemoteWorkerAt: anUrl forBackendHashed: aHash [
	archetypedControllers
		do:
			[ :controller | controller noteRemoteWorkerAt: anUrl forBackendHashed: aHash ]
]

{ #category : #notifications }
TKTArchetypeAwarePool >> noteTaskHasFinished: futureExecution [
	archetypedControllers
		do: [ :a | a noteTaskHasFinished: futureExecution ]
]

{ #category : #accessing }
TKTArchetypeAwarePool >> pool: aTKTCommonQueueWorkerPool [ 
	pool := aTKTCommonQueueWorkerPool
]

{ #category : #accessing }
TKTArchetypeAwarePool >> privateArchetypedControllerFor: archetype [
	^ archetypedControllers
		detect: [ :a | a archetype = archetype ]
		ifNone: [ | new |
			new := TKTArchetypedQueueController new.
			archetypedControllers add: new.
			new
				archetype: archetype pool: self backends: self maxBackends;
				yourself ]
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> privateFuture: aTask [
	^ pool privateFuture: aTask
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> privateSchedule: aTKTGenericTask [
	pool privateSchedule: aTKTGenericTask
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> recoverOngoingTasks: aCollectionOfTaskExecutions [
	aCollectionOfTaskExecutions ifEmpty: [ ^ self ].
	aCollectionOfTaskExecutions
		reject: [ :t | t shouldRetry ]
		thenDo: [ :t | self failTaskExecution: t ].
		
	aCollectionOfTaskExecutions 
		select: [ :t | t shouldRetry ]
		thenDo: [ :aTaskExecution | 
			
			(self privateArchetypedControllerFor: aTaskExecution archetype)
				scheduleTaskExecution: aTaskExecution.
			aTaskExecution markAsRecovered.	
			 ].
	
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> registerNotDeployableTaskExecution: aTaskExecution [
	inverseProxy registerNotDeployable: aTaskExecution
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> registerTaskExecution: aTaskExecution [
	inverseProxy register: aTaskExecution
]

{ #category : #service }
TKTArchetypeAwarePool >> requestTaskForBackend: aHash [
	self logCr: aHash asString , ' requested a task'.
	^ (archetypedControllers
		detect: [ :controller | controller managesBackendId: aHash ])
		requestTaskOrNilForBackend: aHash
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> schedule: aTask [
	aTask asTask schedule: self
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> schedule: aTask timeout: aTimeout [
	^ pool schedule: aTask timeout: aTimeout
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> scheduleArchetypedTask: aTask [
	| execution |
	execution := aTask asTask futureTaskExecutionFor: self.
	(self privateArchetypedControllerFor: aTask archetype)
		scheduleTaskExecutionNotDeployable: execution.
		
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> scheduleTaskExecution: aTaskExecution [
	^ pool scheduleTaskExecution: aTaskExecution
]

{ #category : #scheduling }
TKTArchetypeAwarePool >> scheduleTimeout: timeout on: aTaskExecution [
	^ pool scheduleTimeout: timeout on: aTaskExecution
]

{ #category : #stop }
TKTArchetypeAwarePool >> stop [
	TKTConfiguration watchDog stopWatching: self.
	archetypedControllers do: #stop.
	inverseProxy ifNotNil: [ :r | r stop ].
	inverseProxy := nil.
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
	inverseProxy ifNotNil: [ :r | r stop ].
	inverseProxy := nil.
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

{ #category : #scheduling }
TKTArchetypeAwarePool >> url [
	^ inverseProxy url
]
