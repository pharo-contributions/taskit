"
Watchdog watches the common queue worker pool to ensure the good working of this pool
"
Class {
	#name : #TKTWatchDog,
	#superclass : #TKTService,
	#instVars : [
		'pool'
	],
	#category : 'TaskIt-Worker'
}

{ #category : #'instance creation' }
TKTWatchDog class >> on: aPool [
	^ self new
		initializeWith: aPool;
		start;
		yourself
]

{ #category : #initialization }
TKTWatchDog >> delay [
	^ 2 seconds
]

{ #category : #initialization }
TKTWatchDog >> initializeWith: aPool [
	pool := aPool asWeakReference
]

{ #category : #initialization }
TKTWatchDog >> name [
	^ 'WatchDog - ' , self pool printString
]

{ #category : #initialization }
TKTWatchDog >> pool [
	^ pool at: 1
]

{ #category : #initialization }
TKTWatchDog >> stepService [
	[ self pool ifNil: [ self stop ] ifNotNil: [ :p | self watchDog: p ].
	self delay wait ]
		on: Error
		do: [ :err | self inform: err messageText ]
]

{ #category : #initialization }
TKTWatchDog >> watchDog: aParameterPool [
	aParameterPool failedTasks
		addAll: (aParameterPool workers reject: #isRunning thenCollect: #currentTaskExecution).
	(aParameterPool workers reject: #isRunning) do: #restart.
	aParameterPool manageWorkersBefore.
	aParameterPool manageWorkersAfter
]
