"
I am a process local variable containing the task runner in charge of the current thread. If the current thread is not dominated by a task runner, my default value is the global worker pool.
"
Class {
	#name : #TKTConfiguration,
	#superclass : #DynamicVariable,
	#instVars : [
		'value'
	],
	#category : #'TaskIt-Profiles'
}

{ #category : #accessing }
TKTConfiguration class >> defaultProfile [
	^ #development
]

{ #category : #accessing }
TKTConfiguration class >> development [
	<profile: #development>
	^ TKTProfile
		on:
			{(#debugging -> true).
			(#runner -> TKTCommonQueueWorkerPool createDefault).
			(#poolWorkerProcess -> TKTDebuggWorkerProcess).
			(#process -> TKTRawProcess).
			(#errorHandler -> TKTDebuggerExceptionHandler).
			(#processProvider -> TKTTaskItProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary
]

{ #category : #accessing }
TKTConfiguration class >> errorHandler [
	^ self optionAt: #errorHandler
]

{ #category : #accessing }
TKTConfiguration class >> errorHandler: anErrorHandler during: aBlock [
	^ self optionAt: #errorHandler value: anErrorHandler during: aBlock
]

{ #category : #accessing }
TKTConfiguration class >> optionAt: aKey [
	^ self value at: aKey
]

{ #category : #accessing }
TKTConfiguration class >> optionAt: aKey value: aValue during: aBlock [
	| copy |
	copy := self value copy.
	copy at: aKey put: aValue.
	^ self value: copy during: aBlock
]

{ #category : #accessing }
TKTConfiguration class >> poolWorkerProcess [
	^ self optionAt: #poolWorkerProcess
]

{ #category : #accessing }
TKTConfiguration class >> poolWorkerProcess: anObject during: aBlock [
	^ self optionAt: #poolWorkerProcess value: anObject during: aBlock
]

{ #category : #accessing }
TKTConfiguration class >> process [
	^ self optionAt: #process
]

{ #category : #accessing }
TKTConfiguration class >> process: anObject during: aBlock [
	^ self optionAt: #process value: anObject during: aBlock
]

{ #category : #accessing }
TKTConfiguration class >> processProvider [
	^ self optionAt: #processProvider
]

{ #category : #accessing }
TKTConfiguration class >> processProvider: aProcessProvider during: aBlock [
	^ self optionAt: #processProvider value: aProcessProvider during: aBlock
]

{ #category : #'as yet unclassified' }
TKTConfiguration class >> production [
	<profile: #production>
	^ TKTProfile
		on:
			{
			(#debugging -> false) .
			(#runner -> TKTCommonQueueWorkerPool createDefault).
			(#poolWorkerProcess -> TKTWorkerProcess).
			(#process -> Process).
			(#errorHandler -> TKTExceptionHandler).
			(#processProvider -> TKTPharoProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary
]

{ #category : #accessing }
TKTConfiguration class >> profile: aProfile [
	self soleInstance basicValue ifNotNil: [ :p | p finalizeProfile ].
	self soleInstance value: aProfile.
	aProfile activateProfile
]

{ #category : #accessing }
TKTConfiguration class >> profile: aProfile during: aBlock [
	| return |
	
	return := self value: aProfile during: [aProfile activateProfile. aBlock value].
	aProfile finalizeProfile.
	^ return
]

{ #category : #accessing }
TKTConfiguration class >> profileNamed: aProfileName [
	| profile |
	profile := (self profiles detect: [ :ass | ass key = aProfileName ]) value value.
	profile name: aProfileName.
	self profile: profile
]

{ #category : #accessing }
TKTConfiguration class >> profileNamed: aProfileName during: aBlock [
	| return profile |
	profile := (self profiles detect: [ :ass | ass key = aProfileName ]) value value .
	profile name: aProfileName.
	return := self
		value: profile
		during: [ profile activateProfile.
			aBlock value ].
	profile finalizeProfile.
	^ return
]

{ #category : #accessing }
TKTConfiguration class >> profiles [
	^ (Pragma allNamed: #profile: from: self class to: ProtoObject) asOrderedCollection
		collect: [ :c | c arguments first -> (MessageSend receiver: self selector: c method selector) ]
]

{ #category : #accessing }
TKTConfiguration class >> runner [
	^ self optionAt: #runner
]

{ #category : #accessing }
TKTConfiguration class >> runner: aRunner during: aBlock [
	^ self optionAt: #runner value: aRunner during: aBlock
]

{ #category : #accessing }
TKTConfiguration class >> serviceManager [
	^ self optionAt: #serviceManager
]

{ #category : #accessing }
TKTConfiguration class >> serviceManager: aManager during: aBlock [
	^ self optionAt: #serviceManager value: aManager during: aBlock
]

{ #category : #accessing }
TKTConfiguration class >> test [
	<profile: #test>
	^ TKTProfile
		on:
			{(#debugging -> false).
			(#runner -> TKTCommonQueueWorkerPool createDefault).
			(#poolWorkerProcess -> TKTWorkerProcess).
			(#process -> Process).
			(#errorHandler -> TKTExceptionHandler).
			(#processProvider -> TKTTaskItProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary
]

{ #category : #accessing }
TKTConfiguration >> basicValue [ 
	^ value
]

{ #category : #accessing }
TKTConfiguration >> default [
	| configuration |
	^ value
		ifNil: [ self class profileNamed: self class defaultProfile.
			self assert: value isNotNil ]
]

{ #category : #accessing }
TKTConfiguration >> value: aValue [
	value := aValue
]
