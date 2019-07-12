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
		'resolver'
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
	ZnEasy
		post: master / #deployFutureResult
		data:
			(aSerializer
				writeZnEntityFor:
					{value.
					taskId})
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> informSuccess: value id: taskId serializer: aSerializer [
	ZnEasy
		post: master / #deployFutureResult
		data:
			(aSerializer
				writeZnEntityFor:
					{value.
					taskId})
]

{ #category : #initialization }
TKTForkItIncomingTasksService >> initialize [
	super initialize.
	resolver := self.
	self
		map: 'alive' to: #alive;
		map: 'isFree' to: #isFree;
		map: 'task' to: #task:serializer:;
		map: 'stop' to: #stop.
	
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

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> master: anUrl [
	master := anUrl
]

{ #category : #accessing }
TKTForkItIncomingTasksService >> port [
	^ server port 
]

{ #category : #protocol }
TKTForkItIncomingTasksService >> privateInformBinds [
	| response time timesToTry |
	master ifNil: [ ^ self ].
	timesToTry := 5.
	time := 0.
	[ time := time + 1.
	response := ZnEasy
		post: master / #registerBackend
		data:
			(TKTSerializationStrategy ston
				writeZnEntityFor:
					{server localUrl.
					backendHash}) ]
		doWhileTrue: [ self
				log: 'trying ' , time asString , ' to connect: ' , master asString.
			time asSeconds wait.
			response isError and: [ timesToTry - time >= 0 ] ].
	response isError
		ifTrue: [ self
				error: ' Unable to register as valid frontend ' , response entity asString ]
]

{ #category : #protocol }
TKTForkItIncomingTasksService >> startOn: anAddress [
	
	TKTConfiguration runner poolMaxSize: 3.
	pool ifNil: [ self usePool: TKTConfiguration runner ].
	server := (ZnServer on: 0)
		bindingAddress: (NetNameResolver addressForName: anAddress);
		delegate: self;
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
	future := taskAndId first future: pool.
	future
		onSuccessDo:
			[ :v | resolver informSuccess: v id: taskAndId second serializer: serializer ].
	future
		onFailureDo:
			[ :e | resolver informError: e id: taskAndId second serializer: serializer ]
]

{ #category : #accessing }
TKTForkItIncomingTasksService >> usePool: aPool [
	pool := aPool
]

{ #category : #initialization }
TKTForkItIncomingTasksService >> useResolver: aResolver [
	resolver := aResolver
]
