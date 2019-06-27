"
Forkit Service is the base Facade of the remote image, interfacing the incoming calls (ZnServer managed) to a local default Worker pool
"
Class {
	#name : #TKTForkItService,
	#superclass : #TKTServerDelegate,
	#instVars : [
		'server',
		'pool',
		'master',
		'backendHash'
	],
	#category : #'TaskItForkIt-Worker-RemoteExtentions'
}

{ #category : #'as yet unclassified' }
TKTForkItService class >> allInstancesSize [
	^ self allInstances size
]

{ #category : #'as yet unclassified' }
TKTForkItService class >> registeringOn: aZnUrl backend: aBackendHash [
	^ self new
		master: aZnUrl;
		backendHash: aBackendHash;
		yourself
]

{ #category : #initialization }
TKTForkItService >> alive [
	^ server isRunning & server isListening
]

{ #category : #initialization }
TKTForkItService >> backendHash: aHashNumber [
	backendHash := aHashNumber
]

{ #category : #initialization }
TKTForkItService >> help: request [
	"Reply with a dynamic HTML page containing links to all pages I support"

	^ ZnResponse ok: (ZnEntity html: self generateHelp)
	
]

{ #category : #initialization }
TKTForkItService >> informBinds [
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
TKTForkItService >> informError: value id: taskId [
	ZnEasy
		post: master / #deployFutureResult:
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
TKTForkItService >> informSuccess: value id: taskId [
	ZnEasy
		post: master / #deployFutureResult:
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
TKTForkItService >> initialize [
	super initialize.
	self
		map: 'alive' to: #alive;
		map: 'isFree' to: #isFree;
		map: 'task' to: #task:;
		map: 'stop' to: #stop
]

{ #category : #initialization }
TKTForkItService >> ip [
	^ NetNameResolver stringFromAddress: server bindingAddress
]

{ #category : #initialization }
TKTForkItService >> isFree [
	^ true
]

{ #category : #initialization }
TKTForkItService >> master: anUrl [
	master := anUrl
]

{ #category : #initialization }
TKTForkItService >> port [
	^ server port 
]

{ #category : #initialization }
TKTForkItService >> startOn: anAddress [
	pool := TKTConfiguration runner.
	server := (ZnServer on: 0)
		bindingAddress: (NetNameResolver addressForName: anAddress);
		delegate: self;
		start;
		yourself.
	self informBinds.
]

{ #category : #initialization }
TKTForkItService >> stop [
	^ Smalltalk exit: 0
]

{ #category : #initialization }
TKTForkItService >> task: aRequest [
	| future taskAndId |
	taskAndId := (STONReader on: aRequest entity string readStream) next.
	future := taskAndId first future: pool.
	future
		onSuccessDo: [ :v | self informSuccess: v id: taskAndId second ].
	future onFailureDo: [ :e | self informError: e id: taskAndId second ].
]
