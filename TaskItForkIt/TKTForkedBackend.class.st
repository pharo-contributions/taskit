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
		'defaultSerializerSelector',
		'sent',
		'assignedTasks'
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

{ #category : #public }
TKTForkedBackend >> assignTask: aTaskExecution [
	assignedTasks add: aTaskExecution.
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

{ #category : #service }
TKTForkedBackend >> ensureIsAlive: aRegistry [
	self isAlive
		ifTrue: [ ^ self ].
	self stop.
	self startWith: aRegistry.
	self recoverOngoingTasks: aRegistry
]

{ #category : #initialize }
TKTForkedBackend >> initialize [
	super initialize.
	mutex := Mutex new.
	assignedTasks := OrderedCollection new.
]

{ #category : #'remote-call' }
TKTForkedBackend >> isAlive [
	[ ZnEasy get: self url / #alive.
	^ true ]
		on: Error
		do: [ ^ false ]
]

{ #category : #'remote-call' }
TKTForkedBackend >> isFree [
	^ TKTSerializationStrategy default
		readFromZnEntity: (ZnEasy get: self url / #isFree) entity
]

{ #category : #'remote-call' }
TKTForkedBackend >> isTooBusy [
	^ assignedTasks isNotEmpty
]

{ #category : #'remote-call' }
TKTForkedBackend >> logStatus [
	[ ZnEasy get: self url / #logStatus.
	^ true ]
		on: Error
		do: [ ^ false ]
]

{ #category : #'remote-call' }
TKTForkedBackend >> noteTaskHasFinished: aTaskExecution [
	assignedTasks remove: aTaskExecution ifAbsent: [ "nothing to do " ]
]

{ #category : #'remote-call' }
TKTForkedBackend >> noteTaskScheduled [
	self isTooBusy
		ifFalse: [ [ ZnEasy get: self url / #noteTaskScheduled.
			^ true ]
				on: Error
				do: [ ^ false ] ]
]

{ #category : #service }
TKTForkedBackend >> recoverOngoingTasks [
	assignedTasks
		do: [ :t | 
			t backend: self.
			t doExecuteTask ]
]

{ #category : #service }
TKTForkedBackend >> recoverOngoingTasks: aRegistry [
	assignedTasks := aRegistry filterToStillNeededTasks: assignedTasks.
	assignedTasks
		do: [ :t | 
			t backend: self.
			t doExecuteTask ]
]

{ #category : #'remote-call' }
TKTForkedBackend >> resetWorker [
	[ ZnEasy get: self url / #resetWorker.
	^ true ]
		on: Error
		do: [ ^ false ]
]

{ #category : #testing }
TKTForkedBackend >> respondsToArchetype: anArchetype [
	^ deploy archetype compatibleWith: anArchetype
]

{ #category : #'remote-call' }
TKTForkedBackend >> sendTaskAndProcessResponse: aTask id: aFutureId serializer: aSerializerSelector [
	^ self sendTaskAndProcessResponse: aTask id: aFutureId serializer: aSerializerSelector time: 5
]

{ #category : #'remote-call' }
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

{ #category : #service }
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

{ #category : #private }
TKTForkedBackend >> startupCodeIp: anIp outputFile: anOutputFile with: aRegister [
	^ '
	| service stream |
	Author fullName: ''Forkit''.
	TKTArchetypeAwarePool allInstances do: [: p | p becomeForward:nil].
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

{ #category : #service }
TKTForkedBackend >> stop [
	mutex
		critical: [ url
				ifNotNil: [ [ ZnEasy get: url / #stop.
					1 second wait.
					imageProcess isComplete
						ifFalse: [ imageProcess kill ] ] ifError: [  ].
					url := nil.
					imageProcess := nil ] ]
]

{ #category : #service }
TKTForkedBackend >> stopAndDelete [
	self stop.
	deploy ifNotNil: [ deploy delete ]
]

{ #category : #accessing }
TKTForkedBackend >> url [
	url ifNotNil: [ :u | ^ u ].
	self error: 'Not url setted'
]
