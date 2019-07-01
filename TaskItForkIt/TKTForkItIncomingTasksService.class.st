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

{ #category : #initialization }
TKTForkItIncomingTasksService >> alive [
	^ server isRunning & server isListening
]

{ #category : #initialization }
TKTForkItIncomingTasksService >> backendHash: aHashNumber [
	backendHash := aHashNumber
]

{ #category : #initialization }
TKTForkItIncomingTasksService >> help: request [
	"Reply with a dynamic HTML page containing links to all pages I support"

	^ ZnResponse ok: (ZnEntity html: self generateHelp)
	
]

{ #category : #initialization }
TKTForkItIncomingTasksService >> informBinds [
	master ifNil: [ ^ self ].
	ZnEasy
		post: master / #registerBackend
		data:
			(ZnEntity
				text:
					(String
						streamContents: [ :str | 
							(STONWriter on: str)
								nextPut:
									{server localUrl.
									backendHash} ]))
]

{ #category : #initialization }
TKTForkItIncomingTasksService >> informError: value id: taskId [
	ZnEasy
		post: master / #deployFutureResult
		data:
			(ZnEntity
				text:
					(String
						streamContents: [ :str | 
							(STONWriter on: str)
								nextPut:
									{ value.
									taskId} ]))
]

{ #category : #initialization }
TKTForkItIncomingTasksService >> informSuccess: value id: taskId [
	ZnEasy
		post: master / #deployFutureResult
		data:
			(ZnEntity
				text:
					(String
						streamContents: [ :str | 
							(STONWriter on: str)
								nextPut:
									{value.
									taskId} ]))
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

{ #category : #initialization }
TKTForkItIncomingTasksService >> ip [
	^ NetNameResolver stringFromAddress: server bindingAddress
]

{ #category : #initialization }
TKTForkItIncomingTasksService >> isFree [
	^ true
]

{ #category : #initialization }
TKTForkItIncomingTasksService >> master: anUrl [
	master := anUrl
]

{ #category : #initialization }
TKTForkItIncomingTasksService >> port [
	^ server port 
]

{ #category : #initialization }
TKTForkItIncomingTasksService >> startOn: anAddress [
	pool := TKTConfiguration runner.
	server := (ZnServer on: 0)
		bindingAddress: (NetNameResolver addressForName: anAddress);
		delegate: self;
		start;
		yourself.
		Transcript open. 
	self informBinds.
]

{ #category : #initialization }
TKTForkItIncomingTasksService >> stop [
	^ Smalltalk exit: 0
]

{ #category : #initialization }
TKTForkItIncomingTasksService >> task: aRequest [
	| future taskAndId |
	taskAndId := (STONReader on: aRequest entity string readStream) next.
	future := taskAndId first future: pool.
	future
		onSuccessDo: [ :v | 
			self informSuccess: v id: taskAndId second ].
	future
		onFailureDo: [ :e | 
			self informError: e id: taskAndId second ]
]
