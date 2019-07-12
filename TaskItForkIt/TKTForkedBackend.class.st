"
Backend based that connects to a remote 
"
Class {
	#name : #TKTForkedBackend,
	#superclass : #Object,
	#instVars : [
		'deploy',
		'url',
		'imageProcess',
		'archetype',
		'mutex',
		'defaultSerializerSelector'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #accessing }
TKTForkedBackend >> archetype [
	^ archetype
]

{ #category : #accessing }
TKTForkedBackend >> archetype: aTKTArchetype [
	archetype := aTKTArchetype isCurrentPharo
		ifTrue: [ aTKTArchetype ]
		ifFalse: [ aTKTArchetype + TKTProject forkit ]
]

{ #category : #accessing }
TKTForkedBackend >> defaultSerializerSelector [
	^ defaultSerializerSelector 
]

{ #category : #accessing }
TKTForkedBackend >> defaultSerializerSelector: aSelector [
	defaultSerializerSelector := aSelector
]

{ #category : #accessing }
TKTForkedBackend >> deploy [
	^ deploy
		ifNil: [ TKTConfiguration
				runner: TKTNewProcessTaskRunner new
				during: [ deploy := archetype deploy ] ]
]

{ #category : #accessing }
TKTForkedBackend >> deploy: aDeploy [
	deploy := aDeploy.
	archetype := deploy archetype. 
]

{ #category : #accessing }
TKTForkedBackend >> ensureIsAlive: aRegistry [
	self isAlive
		ifFalse: [ self stop.
			self startWith: aRegistry ]
]

{ #category : #accessing }
TKTForkedBackend >> initialize [
	super initialize.
	mutex := Mutex new
]

{ #category : #accessing }
TKTForkedBackend >> isAlive [
	[ ZnEasy get: self url / #alive.
	^ true ]
		on: Error
		do: [ ^ false ]
]

{ #category : #accessing }
TKTForkedBackend >> isFree [
	^ TKTSerializationStrategy default
		readFromZnEntity: (ZnEasy get: self url / #isFree) entity
]

{ #category : #accessing }
TKTForkedBackend >> respondsToArchetype: anArchetype [
	^ deploy archetype compatibleWith: anArchetype
]

{ #category : #accessing }
TKTForkedBackend >> sendTaskAndProcessResponse: aTask id: aFutureId serializer: aSerializerSelector [
	^ self sendTaskAndProcessResponse: aTask id: aFutureId serializer: aSerializerSelector time: 5
]

{ #category : #accessing }
TKTForkedBackend >> sendTaskAndProcessResponse: aTask id: aFutureId serializer: aSerializerSelector time: aTime [
	aTime = 0
		ifTrue: [ TKTRetryException signal: ' Backend timed out. retry later ' ].
	[ | response |
	response := (self serializerFor: aSerializerSelector)
		writeZnRequestFor:
			{aTask.
			aFutureId}
		to: self url / #task.
	^ response ]
		on: ConnectionTimedOut , ZnUnknownHttpMethod
		do: [ :c | 
			self
				sendTaskAndProcessResponse: aTask
				id: aFutureId
				serializer: aSerializerSelector
				time: aTime - 1 ]
]

{ #category : #accessing }
TKTForkedBackend >> serializerFor: aSerializerSelector [
	| selector |
	selector := aSerializerSelector
		ifNil: [ self defaultSerializerSelector ].
	^ TKTSerializationStrategy resolveSerializer: selector
]

{ #category : #accessing }
TKTForkedBackend >> setUrl: anUrl [
	url := anUrl
]

{ #category : #accessing }
TKTForkedBackend >> startWith: aRegistry [
	| output |
	imageProcess ifNotNil: [ ^ self ].
	output := deploy hash asString asFileReference , 'error'.
	mutex
		critical: [ imageProcess ifNotNil: [ ^ self ].
			imageProcess := self deploy
				startImageNoQuit:
					(self
						startupCodeIp: NetNameResolver loopBackAddress
						outputFile: output
						with: aRegistry) ].
	[ [ self isAlive ]
		whileFalse: [ 
			imageProcess isComplete ifTrue: [ self error: 'Remote image has died' ].
			output exists
				ifTrue: [ self error: output readStream upToEnd ].
			1 seconds wait ] ]
		ensure: [ output ensureDelete ]
]

{ #category : #accessing }
TKTForkedBackend >> startupCodeIp: anIp outputFile: anOutputFile with: aRegister [
	^ '
	| service stream |
	Author fullName: ''Forkit''.
	service := TKTForkItIncomingTasksService registeringOn:''{3}'' asZnUrl backend: {4}. 
	[service startOn: ''{1}''.] on: Error do: [ :e |
		stream := (STONWriter on: ''{2}'' asFileReference writeStream).
		stream nextPut: e messageText; close.
		Smalltalk exit:1 .
		
		].
'
		format:
			{NetNameResolver localAddressString.
			anOutputFile fullName.
			aRegister url.
			self hash asString}
]

{ #category : #accessing }
TKTForkedBackend >> stop [
	mutex
		critical: [ url
				ifNotNil: [ [ ZnEasy get: url / #stop.
					1 second wait.
					imageProcess isComplete
						ifFalse: [ imageProcess terminate ] ] ifError: [  ].
					url := nil.
					imageProcess := nil ] ]
]

{ #category : #accessing }
TKTForkedBackend >> stopAndDelete [
	self stop.
	deploy ifNotNil: [ deploy delete ]
]

{ #category : #accessing }
TKTForkedBackend >> url [
	url ifNotNil: [ :u | ^ u ].
	self error: 'Not url setted'
]
