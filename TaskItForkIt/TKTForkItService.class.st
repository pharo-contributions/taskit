"
Forkit Service is the base Facade of the remote image, interfacing the incoming calls (ZnServer managed) to a local default Worker pool
"
Class {
	#name : #TKTForkItService,
	#superclass : #Object,
	#instVars : [
		'server',
		'pool',
		'prefixMap'
	],
	#category : #'TaskItForkIt-Worker-RemoteExtentions'
}

{ #category : #'as yet unclassified' }
TKTForkItService class >> allInstancesSize [
	^ self allInstances size
]

{ #category : #initialization }
TKTForkItService >> alive [
	^ server isRunning & server isListening
]

{ #category : #initialization }
TKTForkItService >> encodeIntoResponse: anObject [
	| serial |
	serial := String
		streamContents: [ :str | (STONWriter on: str) nextPut: anObject ].
	^ ZnResponse ok: (ZnEntity text: serial)
]

{ #category : #initialization }
TKTForkItService >> generateHelp [
	"Generate an HTML page with links to all pages I support"
	
	^ ZnHtmlOutputStream streamContents: [ :html |
		html page: (self class name, ' Help') do: [  	
			html tag: #h3 with: 'Available Pages'.
			html tag: #ul do: [
				prefixMap keys sorted do: [ :each | 
					html tag: #li do: [ 
						html tag: #a attributes: { #href. each } with: each ] ] ] ] ]
]

{ #category : #initialization }
TKTForkItService >> handleRequest: request [
	| prefix prefixHandler |
	prefix := request uri isSlash
		ifTrue: [ prefixMap at: '/' ifAbsent: [ nil ] ]
		ifFalse: [ request uri firstPathSegment ].
	prefixHandler := prefixMap at: prefix ifAbsent: [ nil ].
	[ prefixHandler isNil
		ifFalse: [ ^ self
				encodeIntoResponse: ((MessageSend receiver: self selector: prefixHandler) cull: request) ] ]
		on: Error
		do: [ :e | ^ self encodeIntoResponse: e ].
	^ ZnResponse notFound: request uri
]

{ #category : #initialization }
TKTForkItService >> help: request [
	"Reply with a dynamic HTML page containing links to all pages I support"

	^ ZnResponse ok: (ZnEntity html: self generateHelp)
	
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
TKTForkItService >> map: prefix to: handler [
	"Arrange for the receiver to dispatch requests matching prefix to handler.
	Handler can be a symbol naming a method in the receiver, 
	or a block accepting the request and producing the response.
	The special prefix '/' is resolved first and can refer to another prefix."
	
	self prefixMap 
		at: prefix
		put: handler
		
]

{ #category : #initialization }
TKTForkItService >> port [
	^ server port 
]

{ #category : #initialization }
TKTForkItService >> prefixMap [
	^ prefixMap ifNil: [ prefixMap := Dictionary new ]
]

{ #category : #initialization }
TKTForkItService >> startOn: anAddress [
	pool := TKTConfiguration runner.
	server := (ZnServer on: 0)
		bindingAddress: (NetNameResolver addressForName: anAddress);
		delegate: self;
		start;
		yourself
]

{ #category : #initialization }
TKTForkItService >> stop [
	^ Smalltalk exit: 0
]

{ #category : #initialization }
TKTForkItService >> task: aRequest [
	| future timeout |
	timeout := 1000.
	future := (STONReader on: aRequest entity string readStream) next
		future: pool.
	^ future synchronizeTimeout: timeout seconds
]
