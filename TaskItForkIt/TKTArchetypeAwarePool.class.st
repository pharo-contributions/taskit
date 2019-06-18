"
An archetype aware pool is a simple dispatcher of tasks .It spawn a workerpool per archetype. The classical taskit is extended to make it tasks to use TKTArchetype thisImage. 
"
Class {
	#name : #TKTArchetypeAwarePool,
	#superclass : #Object,
	#instVars : [
		'archetypedPools'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #creating }
TKTArchetypeAwarePool class >> createDefault [
	^ self new 
]

{ #category : #accessing }
TKTArchetypeAwarePool >> amountOfTasksAt: aTKTArchetype [
	^ archetypedPools
		at: aTKTArchetype
		ifPresent: [ :q | q taskQueueSize  ]
		ifAbsent: [ 0 ]
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> future: aTask [
	^ (self workerFor: aTask archetype) future: aTask
]

{ #category : #testing }
TKTArchetypeAwarePool >> includesArchetype: aTKTArchetype [
	^ archetypedPools includesKey: aTKTArchetype
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> initialize [
	super initialize.
	archetypedPools := Dictionary new.
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
TKTArchetypeAwarePool >> schedule: aTask [
	^ (self workerFor: aTask archetype) schedule: aTask
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> schedule: aTask timeout: aTimeout [
	^ (self workerFor: aTask archetype) schedule: aTask timeout: aTimeout
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> scheduleTimeout: timeout on: aTaskExecution [
	^ (self workerFor: aTaskExecution archetype)
		scheduleTimeout: timeout
		on: aTaskExecution
]

{ #category : #stop }
TKTArchetypeAwarePool >> stop [
	archetypedPools valuesDo: #stop
]

{ #category : #accessing }
TKTArchetypeAwarePool >> taskQueueSize: aTKTArchetype [
	^ (archetypedPools at: aTKTArchetype ifAbsent: [ ^ 0 ]) taskQueueSize
]

{ #category : #'public - mutexed' }
TKTArchetypeAwarePool >> workerFor: anArchetype [
	^ archetypedPools
		at: anArchetype
		ifAbsentPut: [ anArchetype = TKTArchetype thisImage
				ifTrue: [ TKTCommonQueueWorkerPool createDefault ]
				ifFalse: [ 
					TKTArchetypedWorkerPool createFor: anArchetype ] ]
]
