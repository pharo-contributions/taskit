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
		'backendHash'
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

	^ ZnResponse ok: (ZnEntity html: self generateHelp)
	
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> informError: value id: taskId [
	ZnEasy
		post: master / #deployFutureResult
		data:
			(ZnEntity
				bytes:
					(ByteArray
						streamContents: [ :str | 
							FLSerializer
								serialize:
									{value.
									taskId}
								on: str ]))
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
TKTForkItIncomingTasksService >> informSuccess: value id: taskId [
	ZnEasy
		post: master / #deployFutureResult
		data:
			(ZnEntity
				bytes:
					(ByteArray
						streamContents: [ :str | 
							FLSerializer
								serialize:
									{value.
									taskId}
								on: str ]))
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
	self
		map: 'alive' to: #alive;
		map: 'isFree' to: #isFree;
		map: 'task' to: #task:;
		map: 'stop' to: #stop
]

{ #category : #accessing }
TKTForkItIncomingTasksService >> ip [
	^ NetNameResolver stringFromAddress: server bindingAddress
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> isFree [
	^ true
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
	master ifNil: [ ^ self ].
	ZnEasy
		post: master / #registerBackend
		data:
			(TKTSerializationStrategy ston
				writeZnEntityFor:
					{server localUrl.
					backendHash})
]

{ #category : #protocol }
TKTForkItIncomingTasksService >> startOn: anAddress [
	pool := TKTConfiguration runner.
	server := (ZnServer on: 0)
		bindingAddress: (NetNameResolver addressForName: anAddress);
		delegate: self;
		start;
		yourself.
	self privateInformBinds.
]

{ #category : #protocol }
TKTForkItIncomingTasksService >> stop [
	^ Smalltalk exit: 0
]

{ #category : #'server commands' }
TKTForkItIncomingTasksService >> task: aRequest [
	| future taskAndId serializer |
	self halt.
	taskAndId := TKTSerializationStrategy default
		readFromZnEntity: aRequest entity.
	serializer := TKTSerializationStrategy default
		serializerFor: aRequest entity.
	future := taskAndId first future: pool.
	future
		onSuccessDo:
			[ :v | self informSuccess: v id: taskAndId second serializer: serializer ].
	future
		onFailureDo:
			[ :e | self informError: e id: taskAndId second serializer: serializer ]
]
