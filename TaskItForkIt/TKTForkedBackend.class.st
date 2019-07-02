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
		'mutex'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #accessing }
TKTForkedBackend >> archetype: aTKTArchetype [
	archetype := aTKTArchetype + TKTProject forkit
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
	^ deploy archetype = anArchetype
		or: [ deploy archetype parent = anArchetype ]
]

{ #category : #accessing }
TKTForkedBackend >> sendTaskAndProcessResponse: aTask id: aFutureId serializer: aSerializerSelector [
	[| response |
	response := ZnEasy
		post: self url / #task
		data:
			((TKTSerializationStrategy resolveSerializer: aSerializerSelector)
				writeZnEntityFor:
					{aTask.
					aFutureId}).
	response := TKTSerializationStrategy default
		readFromZnEntity: response entity.
	(response isKindOf: Exception)
		ifTrue: [ ^ response signalIn: thisContext ].
	^ response] on: ConnectionTimedOut do: [ :c | TKTRetryException signal: ' Backend timed out. retry later '.  ]
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
		whileFalse: [ output exists
				ifTrue: [ self error: output readStream upToEnd ].
			1 seconds wait ] ]
		ensure: [ output ensureDelete ]
]

{ #category : #accessing }
TKTForkedBackend >> startupCodeIp: anIp outputFile: anOutputFile with: aRegister [
	^ '
	| service stream |

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
TKTForkedBackend >> url [
	url ifNotNil: [ :u | ^ u ].
	self error: 'Not url setted'
]
