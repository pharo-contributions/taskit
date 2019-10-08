"
TKTProcess is this framework reification of processing. This is a quite low level class for the idea of the framework
"
Class {
	#name : #TKTProcess,
	#superclass : #Object,
	#instVars : [
		'process',
		'messageSend',
		'processAnnotation',
		'priority',
		'name'
	],
	#classInstVars : [
		'announcer'
	],
	#category : 'TaskItProcesses'
}

{ #category : #'instance creation' }
TKTProcess class >> forMessageSend: aMessageSend [
	^ self new
		messageSend: aMessageSend;
		yourself
]

{ #category : #announcements }
TKTProcess class >> resetAnnouncer [
	^ announcer := Announcer new
]

{ #category : #'instance creation' }
TKTProcess class >> send: aSelector to: anObject [
	^ self forMessageSend: (MessageSend receiver: anObject selector: aSelector)
]

{ #category : #'instance creation' }
TKTProcess class >> send: aSelector with: anArrayOfParameters to: anObject [
	^ self forMessageSend: (MessageSend receiver: anObject selector: aSelector arguments: anArrayOfParameters)
]

{ #category : #announcements }
TKTProcess class >> uniqueAnnouncer [
	^ announcer ifNil: [ self resetAnnouncer ].
]

{ #category : #annotations }
TKTProcess >> annotate: aTag with: aValue [
	self processAnnotation at: aTag put: aValue.
]

{ #category : #annotations }
TKTProcess >> annotation: aTag [
	^ self processAnnotation at: aTag ifAbsent: [ nil ]
]

{ #category : #announce }
TKTProcess >> announce: anAnnouncement [
	self class uniqueAnnouncer announce: anAnnouncement.
]

{ #category : #actions }
TKTProcess >> cancel [
	self cancelIfNotRunning: [ self error: 'Process is not running' ]
]

{ #category : #running }
TKTProcess >> cancelIfNotRunning: aBlock [
	self
		ifRunning: [ self ifSameProcess: [ self privateFinalizePharoProcess ] ifDifferentProcess: [ self privateAskForCancel ] ]
		ifNotRunning: aBlock
]

{ #category : #private }
TKTProcess >> createCancelContextFor: aSuspendedContext [
	| method |
	method := self class lookupSelector: #privateCancelExecutionFromSuspendedContext:.
	^ (Context
		sender: nil
		receiver: self
		method: method
		arguments: {aSuspendedContext})
		privRefresh;
		yourself
]

{ #category : #misc }
TKTProcess >> createContext [
	| method |
	method := self class lookupSelector: #privateExecuteAndFinalizeProcess.
	^ (Context
		sender: nil
		receiver: self
		method: method
		arguments: {})
		privRefresh;
		yourself
]

{ #category : #testing }
TKTProcess >> ifRunning: aBlockClosure [
	^ self isRunning
		ifTrue: [ aBlockClosure value ]
		ifFalse: [ nil ]
]

{ #category : #testing }
TKTProcess >> ifRunning: aBlock ifNotRunning: anOtherBlock [
	^ self isRunning
		ifTrue: [ aBlock value ]
		ifFalse: [ anOtherBlock value ]
]

{ #category : #testing }
TKTProcess >> ifSameProcess: aBlock ifDifferentProcess: anOtherBlock [
	^ self isRunningInTheSameProcess
		ifTrue: [ aBlock value ]
		ifFalse: [ anOtherBlock value ]
]

{ #category : #testing }
TKTProcess >> isRelatedWith: anObject [
	^ messageSend ifNotNil: [ messageSend receiver = anObject ] ifNil: [ false ]
]

{ #category : #testing }
TKTProcess >> isRunning [
	^ process isNotNil and: [ process isTerminated not ]
]

{ #category : #testing }
TKTProcess >> isRunningInTheSameProcess [
	^ Processor activeProcess effectiveProcess = process
]

{ #category : #testing }
TKTProcess >> isSuspended [
	^ process ifNotNil: [ :p | p isSuspended ] ifNil: [ false ]
]

{ #category : #testing }
TKTProcess >> isTaskItRawProcess [
	^ process isTaskItRawProcess
]

{ #category : #'API Pharo process' }
TKTProcess >> isTerminated [
	^ self isRunning not
]

{ #category : #'as yet unclassified' }
TKTProcess >> masterProcessHolder: aTKTRawProcessHolder [
	^ process masterProcessHolder: aTKTRawProcessHolder
]

{ #category : #accessing }
TKTProcess >> messageSend [
	^ messageSend
]

{ #category : #accessing }
TKTProcess >> messageSend: aMessageSend [
	messageSend := aMessageSend
]

{ #category : #accessing }
TKTProcess >> name [
	^ name
		ifNil: [ name := 'Process: '
				,
					(messageSend
						ifNil: [ '' ]
						ifNotNil: [ '#' , messageSend selector , ' -> ' , messageSend receiver printString  ]) ]
]

{ #category : #'as yet unclassified' }
TKTProcess >> name: aName [ 	
	name := aName 
]

{ #category : #printing }
TKTProcess >> printOn: aStream [
	^ self name printOn: aStream
]

{ #category : #accessing }
TKTProcess >> priority [
	^ process priority
]

{ #category : #accessing }
TKTProcess >> priority: aPriority [
	priority := aPriority.
	self ifRunning: [ process priority: aPriority ]
]

{ #category : #private }
TKTProcess >> privateAskForCancel [
	| suspendedContext |
	self privateEnsureNotInSameProcess.
	process suspend.
	suspendedContext := process suspendedContext.
	process suspendedContext: (self createCancelContextFor: suspendedContext).
	process resume
]

{ #category : #private }
TKTProcess >> privateCancelExecutionFromSuspendedContext: aSuspendedContext [
	self privateEnsureProcess.
	self announce: (TKTProcessCancelledByThirdThread forProcess: self andSuspendedContext: aSuspendedContext).
	self privateFinalizePharoProcess.
]

{ #category : #private }
TKTProcess >> privateCreatePharoProcess [
	^ process := TKTConfiguration process
		forContext: self createContext
		priority: self spawnPriority
]

{ #category : #private }
TKTProcess >> privateEnsureNotInSameProcess [
	self assert: self isRunningInTheSameProcess not
]

{ #category : #private }
TKTProcess >> privateEnsureProcess [
	self assert: self isRunningInTheSameProcess
]

{ #category : #private }
TKTProcess >> privateExecuteAndFinalizeProcess [
	self privateExecution.
	self privateFinalizePharoProcess
]

{ #category : #private }
TKTProcess >> privateExecution [
	self privateEnsureProcess.
	self announce: (TKTProcessStarted forProcess: self).
	messageSend value.
	
]

{ #category : #private }
TKTProcess >> privateFinalizePharoProcess [
	self privateEnsureProcess.
	messageSend := nil.
	process
		ifNotNil: [ 
			| pr |
			self announce: (TKTProcessFinishing forProcess: self).
			pr := process.
			process := nil.
			pr terminate ]
]

{ #category : #accessing }
TKTProcess >> processAnnotation [
	^ processAnnotation ifNil: [ processAnnotation := WeakValueDictionary new ]
]

{ #category : #suspend }
TKTProcess >> resume [
	process isSuspended
		ifTrue: [ process resume.
			self announce: (TKTProcessResumed forProcess: self) ]
]

{ #category : #running }
TKTProcess >> run [
	self ifRunning: [ self error: 'Process is already running' ] ifNotRunning: [ self privateCreatePharoProcess resume ]
]

{ #category : #private }
TKTProcess >> spawnPriority [
	^ priority ifNil: [ Processor activePriority ]
]

{ #category : #actions }
TKTProcess >> suspend [
	process isSuspended
		ifFalse: [ 
			process suspend.
			self announce: (TKTProcessSuspended forProcess: self) ]
]

{ #category : #controlling }
TKTProcess >> terminate [
	process
		ifNotNil: [ 
			process terminate.
			process := nil ].
	messageSend := nil.
]
