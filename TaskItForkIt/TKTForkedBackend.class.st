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
	archetype := (aTKTArchetype + TKTProject forkit).
	
]

{ #category : #accessing }
TKTForkedBackend >> deploy [
	^ deploy ifNil: [ deploy := archetype deploy ]
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
TKTForkedBackend >> sendTaskAndProcessResponse: aTask [
	| response |
	response := ZnEasy
		post: self url / #task
		data:
			(ZnEntity
				text:
					(String
						streamContents:
							[ :str | (STONWriter on: str) nextPut: aTask ])).
	response := (STONReader on: response entity string readStream) next.
	(response isKindOf: Exception)
		ifTrue: [ ^ response signalIn: thisContext ].
	^ response
]

{ #category : #accessing }
TKTForkedBackend >> start [
	| ipPort |
	imageProcess ifNotNil: [ ^ self ].
	mutex
		critical: [ imageProcess ifNotNil: [ ^ self ].
			imageProcess := self deploy
				startImageNoQuit:
					(self
						startupCodeIp: NetNameResolver loopBackAddress
						outputFile: deploy hash asString asFileReference , '.start').
			[ (deploy hash asString asFileReference , '.start') exists ]
				whileFalse: [ 10 seconds wait ].
			ipPort := (STONReader
				on: (deploy hash asString asFileReference , '.start') readStream)
				next.
			url := ('http://{1}:{2}/'
				format:
					{(ipPort at: 2).
					(ipPort at: 1) asString}) asZnUrl ].
	self assert: self isAlive
]

{ #category : #accessing }
TKTForkedBackend >> startupCodeIp: anIp outputFile: anOutputFile [
	^ '
	| service stream |
	stream := (STONWriter on: ''{2}'' asFileReference writeStream).
	service := TKTForkItService new.
	[service startOn: ''{1}''.
		stream nextPut:
			\{service port asString.
			service ip\};
		close] on: Error do: [ :e | stream nextPut: e; close].
'
		format:
			{NetNameResolver localAddressString.
			anOutputFile fullName}
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
	self start.
	^ self url
]
