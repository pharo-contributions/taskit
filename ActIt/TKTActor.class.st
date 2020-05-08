"
actor
"
Class {
	#name : #TKTActor,
	#superclass : #Object,
	#instVars : [
		'model',
		'runner',
		'actorModificationMutex'
	],
	#category : #'ActIt-Kernel'
}

{ #category : #accessing }
TKTActor class >> exceptionHandler [
	^ TKTDebuggerExceptionHandler
]

{ #category : #initialize }
TKTActor >> beLocalThreadActor [
	self isLocalThreadActor
		ifTrue: [ ^ self ].
	self installRunner: TKTLocalProcessTaskRunner new
]

{ #category : #initialize }
TKTActor >> beUIActor [
	self isUIActor
		ifTrue: [ ^ self ].
	self installRunner: TKTUIProcessTaskRunner new
]

{ #category : #initialize }
TKTActor >> beWorkerActor [
	| worker |
	self isWorkerActor
		ifTrue: [ ^ self ].
	worker := TKTWorker new.
	worker name: ('Actor-{ID}' format: {(#ID -> UUID new)} asDictionary).
	worker queue: TKTMailBox new.
	self installRunner: worker.
	worker start
]

{ #category : #accessing }
TKTActor >> doesNotUnderstand: aMessage [
	^ self send: aMessage
]

{ #category : #initialize }
TKTActor >> ensureRunnerIsSwitchable [
	self assert: (self mailbox isNil or: [ self mailbox isEmpty ])
]

{ #category : #accessing }
TKTActor >> exceptionHandler [
	^ self class exceptionHandler
]

{ #category : #initialize }
TKTActor >> initializeWith: aTKTActorBehaviour [
	self assert: model isNil.
	actorModificationMutex := Mutex new.
	model := aTKTActorBehaviour.
	self beReadOnlyObject.
	self beWorkerActor.
]

{ #category : #initialize }
TKTActor >> installRunner: aRunner [
	aRunner exceptionHandler: self exceptionHandler.
	actorModificationMutex
		critical: [ self ensureRunnerIsSwitchable.
			self beWritableObject.
			runner := aRunner.
			self beReadOnlyObject ]
]

{ #category : #initialize }
TKTActor >> isLocalThreadActor [
	^ runner ifNil: [ false ] ifNotNil: [ runner isLocalThreadRunner ]
]

{ #category : #initialize }
TKTActor >> isUIActor [
	^ runner ifNil: [ false ] ifNotNil: [ runner isUIRunner ]
]

{ #category : #initialize }
TKTActor >> isWorkerActor [
	^ runner ifNil: [ false ] ifNotNil: [ runner isWorker ]
]

{ #category : #accessing }
TKTActor >> mailbox [
	^ self isWorkerActor 
		ifTrue: [ runner queue copy
				beReadOnlyObject;
				yourself ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
TKTActor >> model [
	^ model
]

{ #category : #sending }
TKTActor >> send: aMessage [
	| messagesend future |
	messagesend := MessageSend receiver: model selector: aMessage selector arguments: aMessage arguments.
	actorModificationMutex critical: [ future := runner future: messagesend ].
	^ future
]
