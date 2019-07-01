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
	^ (STONReader
		on: (ZnEasy get: self url / #isFree) entity string readStream) next
]

{ #category : #accessing }
TKTForkedBackend >> respondsToArchetype: anArchetype [
	^ deploy archetype = anArchetype
]

{ #category : #accessing }
TKTForkedBackend >> sendTaskAndProcessResponse: aTask id: aFutureId [
	| response |
	response := ZnEasy
		post: self url / #task
		data:
			(ZnEntity
				text:
					(String
						streamContents: [ :str | 
							(STONWriter on: str)
								nextPut: {aTask. aFutureId} ])).
	response := (STONReader on: response entity string readStream) next.
	(response isKindOf: Exception)
		ifTrue: [ ^ response signalIn: thisContext ].
	^ response
]

{ #category : #accessing }
TKTForkedBackend >> setUrl: anUrl [
	url := anUrl
]

{ #category : #accessing }
TKTForkedBackend >> startWith: aRegistry [
	| output |
	imageProcess ifNotNil: [ ^ self ].
	output := deploy hash asString asFileReference , 'start'.
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
		ensure: [ output delete ]
]

{ #category : #accessing }
TKTForkedBackend >> startupCodeIp: anIp outputFile: anOutputFile with: aRegister [
	^ '
	| service stream |
	
	service := TKTForkItIncomingTasksService registeringOn:''{3}'' asZnUrl backend: {4}. 
	[service startOn: ''{1}''.
		stream nextPut:
			\{service port asString.
			service ip\};
		close] on: Error do: [ :e | 
		stream := (STONWriter on: ''{2}'' asFileReference writeStream).
		stream nextPut: e; close].
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
