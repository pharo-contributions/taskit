"
Common queue worker pool has in common queue. This makes that all the workers wait over the same queue 
"
Class {
	#name : #TKTCommonQueueWorkerPool,
	#superclass : #Object,
	#traits : 'TTaskScheduler - {#scheduleTaskExecution:}',
	#classTraits : 'TTaskScheduler classTrait',
	#instVars : [
		'poolMaxSize',
		'workers',
		'taskQueue',
		'failedTasks',
		'name'
	],
	#category : 'TaskIt-Worker'
}

{ #category : #current }
TKTCommonQueueWorkerPool class >> createDefault [
	^ self new
		name: 'CommonPool-' , UUID new asString;
		poolMaxSize: 4;
		yourself
]

{ #category : #accessing }
TKTCommonQueueWorkerPool >> failedTasks [
	^ failedTasks
]

{ #category : #testing }
TKTCommonQueueWorkerPool >> freeWorkers [
	^ workers select: [ :each | each isFree ]
]

{ #category : #schedulling }
TKTCommonQueueWorkerPool >> getAvailableWorker [
	| worker |
	worker := self freeWorkers
		nextIfNone: [ self size < poolMaxSize
				ifTrue: [ self newWorker ]
				ifFalse: [ self freeWorkers next ] ].
	^ worker
]

{ #category : #initialization }
TKTCommonQueueWorkerPool >> initialize [
	super initialize.
	workers := Set new.
	failedTasks := OrderedCollection new.
	taskQueue := AtomicSharedQueue new.
	self name: 'Worker' , self identityHash asString.
	
]

{ #category : #testing }
TKTCommonQueueWorkerPool >> isFree [

	^ workers allSatisfy: [ :each | each isFree ]
]

{ #category : #schedulling }
TKTCommonQueueWorkerPool >> manageWorkersAfter [
	| free |

	free := workers select: #isFree.
	free size - taskQueue size > (poolMaxSize / 2)
		ifTrue: [ self removeIdleWorker ]
]

{ #category : #schedulling }
TKTCommonQueueWorkerPool >> manageWorkersBefore [
	| free toremove |
	toremove := workers reject: #isRunning.
"	toremove isEmpty
		ifFalse: [ self halt ].

"	" do: [ :w | w stop ]."

	free := workers select: #isFree.
	free size - taskQueue size <= 0
		ifTrue: [ self spawnWorkerIfNeeded ]
]

{ #category : #accessing }
TKTCommonQueueWorkerPool >> name [
	^ name
]

{ #category : #accessing }
TKTCommonQueueWorkerPool >> name: aString [
	name := aString
]

{ #category : #schedulling }
TKTCommonQueueWorkerPool >> newWorker [	
	^ workers add: (TKTWorker new
		name: self name, ' Worker #', (self size + 1) asString;
		taskQueue: taskQueue;
		start)
]

{ #category : #accessing }
TKTCommonQueueWorkerPool >> poolMaxSize: anInteger [ 
	
	poolMaxSize := anInteger
]

{ #category : #printing }
TKTCommonQueueWorkerPool >> printOn: aStream [
	| freeWorkers | 
	freeWorkers := workers select: #isFree.
	aStream
		nextPutAll: 'TKTCommonQueueWorkerPool(';
		nextPutAll: 'name:';
		nextPutAll: name;
		nextPutAll: 'poolMaxSize: ';
		print: poolMaxSize;
		nextPutAll: '; busyWorkers: ';
		print: workers size - freeWorkers size;
		nextPutAll: '; freeWorkers: ';
		print: freeWorkers size;
		nextPutAll: ')'
]

{ #category : #schedulling }
TKTCommonQueueWorkerPool >> purge [
	taskQueue removeAll
]

{ #category : #removing }
TKTCommonQueueWorkerPool >> removeIdleWorker [
	| removing |
	removing := (workers select: #isFree) anyOne.
	removing stop.
	workers remove: removing
]

{ #category : #'as yet unclassified' }
TKTCommonQueueWorkerPool >> reset [
	self purge.
	workers do: #restart
]

{ #category : #schedulling }
TKTCommonQueueWorkerPool >> scheduleTaskExecution: aTaskExecution [
	self manageWorkersBefore.
	taskQueue nextPut: aTaskExecution.
]

{ #category : #accessing }
TKTCommonQueueWorkerPool >> size [
	
	^ workers size
]

{ #category : #schedulling }
TKTCommonQueueWorkerPool >> spawnWorkerIfNeeded [
	workers size < poolMaxSize
		ifTrue: [ self newWorker ]
]

{ #category : #accessing }
TKTCommonQueueWorkerPool >> start [
	TKTWatchDog on: self
]

{ #category : #accessing }
TKTCommonQueueWorkerPool >> stop [
	workers do: #stop.
	workers removeAll
]

{ #category : #accessing }
TKTCommonQueueWorkerPool >> workers [
	
	^ workers copy
]
