Class {
	#name : #TKTForkedWorkerProcess,
	#superclass : #TKTWorkerProcess,
	#instVars : [
		'deploy',
		'url',
		'imageProcess'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #accessing }
TKTForkedWorkerProcess >> archetype: aTKTArchetype [  
	deploy := (aTKTArchetype + TKTProject forkit) deploy.
	
]

{ #category : #accessing }
TKTForkedWorkerProcess >> isAlive [
	[ ZnEasy get: url / #alive.
	^ true ]
		on: Error
		do: [ ^ false ]
]

{ #category : #accessing }
TKTForkedWorkerProcess >> isFree [
	^ ZnEasy get: url / #isFree
]

{ #category : #accessing }
TKTForkedWorkerProcess >> isRunning [
	
	^	self isAlive
]

{ #category : #'instance creation' }
TKTForkedWorkerProcess >> new [
	" Polymorphic hook"

	^ self
]

{ #category : #accessing }
TKTForkedWorkerProcess >> sendTaskAndProcessResponse: aTask [
	| response |
	response := ZnEasy
		post: url / #task
		data:
			(String streamContents: [ :str | (STONWriter on: str) nextPut: aTask ]).
	response := (STONReader on: response entity string readStream) next.
	(response at: #isError)
		ifTrue: [ ^ self error: (response at: #result) ].
	^ response at: #result
]

{ #category : #accessing }
TKTForkedWorkerProcess >> start [
	| ipPort |
	imageProcess := deploy
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
			(ipPort at: 1) asString}) asZnUrl.
	self assert: self isAlive
]

{ #category : #accessing }
TKTForkedWorkerProcess >> startupCodeIp: anIp outputFile: anOutputFile [
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
TKTForkedWorkerProcess >> stop [
	^ ZnEasy get: url / #stop
]
