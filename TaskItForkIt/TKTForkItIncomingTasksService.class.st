"
Forkit Service is the base Facade of the remote image, interfacing the incoming calls (ZnServer managed) to a local default Worker pool
"
Class {
	#name : #TKTForkItIncomingTasksService,
	#superclass : #TKTServerDelegate,
	#instVars : [
		'server',
		'pool',
		'master',
		'backendHash',
		'resolver',
		'taskScheduledAlreadyRequested'
	],
	#category : #'TaskItForkIt-Worker-Server'
}

{ #category : #'as yet unclassified' }
TKTForkItIncomingTasksService class >> allInstancesSize [
	^ self allInstances size
]

{ #category : #'as yet unclassified' }
TKTForkItIncomingTasksService class >> registeringOn: aZnUrl backend: aBackendHash [
	^ self new
		master: aZnUrl;
		backendHash: aBackendHash;
		yourself
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> alive [
	^ server isRunning & server isListening
]

{ #category : #accessing }
TKTForkItIncomingTasksService >> backendHash: aHashNumber [
	backendHash := aHashNumber
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> garbageCollect [
	^ [ 10 timesRepeat: [ Smalltalk garbageCollect ] ] timeToRun / 10
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> help: request [
	"Reply with a dynamic HTML page containing links to all pages I support"

	^ ZnResponse
		ok:
			((TKTSerializationStrategy resolveSerializer: #ston)
				writeZnEntityFor: self generateHelp)
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> informError: value id: taskId serializer: aSerializer [
	self logCr: ' Task finished with errors . Informing result '.
	aSerializer
		writeZnRequestFor:
			{value.
			taskId}
		to: master / #deployFutureResult
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> informSuccess: value id: taskId serializer: aSerializer [
	self logCr:' Task finished successfully. Informing result '. 
	aSerializer
		writeZnRequestFor:
			{value.
			taskId}
		to: master / #deployFutureResult
]

{ #category : #initialization }
TKTForkItIncomingTasksService >> initialize [
	super initialize.
	resolver := self.
	taskScheduledAlreadyRequested := false.
	self
		map: 'alive' to: #alive;
		map: 'isFree' to: #isFree;
		map: 'task' to: #task:serializer:;
		map: 'stop' to: #stop;
		map: 'noteTaskScheduled' to: #noteTaskScheduled;
		map: 'resetWorker' to: #resetWorker;
		map: 'logStatus' to: #logStatus
]

{ #category : #accessing }
TKTForkItIncomingTasksService >> ip [
	^ NetNameResolver stringFromAddress: server bindingAddress
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> isFree [
	^ true
]

{ #category : #protocol }
TKTForkItIncomingTasksService >> log: aString [
	self logCr: aString
]

{ #category : #accessing }
TKTForkItIncomingTasksService >> logCr: anObject [
	super logCr: anObject printString
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> logStatus [
	self logCr: self pool. 
	self logCr: self pool taskQueue
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> master: anUrl [
	master := anUrl
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> noteTaskScheduled [
	self logCr: ' a task has being scheduled! '.
	taskScheduledAlreadyRequested
		ifFalse: [ taskScheduledAlreadyRequested := true.
			[ [ self requestAndProcessTask ] asTask schedule: self pool ]
				on: Error
				do: [ :e | self logCr: e messageText ] ].
	^ true
]

{ #category : #'as yet unclassified' }
TKTForkItIncomingTasksService >> pool [
	^ pool ifNil: [ TKTConfiguration runner ]
]

{ #category : #accessing }
TKTForkItIncomingTasksService >> port [
	^ server port 
]

{ #category : #protocol }
TKTForkItIncomingTasksService >> privateInformBinds [
	| time timesToTry keepTrying |
	master ifNil: [ ^ self ].
	timesToTry := 5.
	time := 0.
	keepTrying := false.
	self
		log: 'trying ' , time asString , ' to connect: ' , master asString.
	TKTSerializationStrategy ston
		writeZnRequestFor:
			{server localUrl.
			backendHash}
		to: master / #registerBackend
	"
	[ time := time + 1.
	[ self
		log: 'trying ' , time asString , ' to connect: ' , master asString.
	time asSeconds wait.
	TKTSerializationStrategy ston
		writeZnRequestFor:
			{server localUrl.
			backendHash}
		to: master / #registerBackend ]
		on: Error
		do: [ :e | keepTrying := true ] ]
		doWhileTrue: [ keepTrying and: [ timesToTry - time >= 0 ] ].
	keepTrying
		ifTrue: [ self error: ' Unable to register as valid frontend ' ]"
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> requestAndProcessTask [
	TKTSerializationStrategy default
		writeZnRequestFor: backendHash
		to: master / #requestTask.
	taskScheduledAlreadyRequested := false.
	
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> resetWorker [
	self pool taskQueue removeAll.
]

{ #category : #protocol }
TKTForkItIncomingTasksService >> startOn: anAddress [
	TKTConfiguration profileNamed: #lightweight.
	server := (ZnServer on: 0)
		bindingAddress: (NetNameResolver addressForName: anAddress);
		delegate: self;
		maximumEntitySize: 30 * 1024 * 1024;
		"30Mb"
			start;
		yourself.
	self privateInformBinds
]

{ #category : #protocol }
TKTForkItIncomingTasksService >> stop [
	^ Smalltalk exit: 0
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> task: taskAndId serializer: serializer [
	| future |
	self logCr: ' received task to execute'.
	self logCr: taskAndId.
	future := taskAndId first future: self pool.
	future
		onSuccessDo: [ :v | 
			[ resolver
				informSuccess: v
				id: taskAndId second
				serializer: serializer ]
				ensure: [ self requestAndProcessTask ] ].
	future
		onFailureDo: [ :e | 
			[ resolver informError: e id: taskAndId second serializer: serializer ]
				ensure: [ self requestAndProcessTask ] ]
]

{ #category : #'as yet unclassified' }
TKTForkItIncomingTasksService >> usePool: aPool [
	pool := aPool 
]

{ #category : #initialization }
TKTForkItIncomingTasksService >> useResolver: aResolver [
	resolver := aResolver
]
