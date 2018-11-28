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

{ #category : #accessing }
TKTConfiguration class >> profile: aProfile [
	^ self soleInstance value: (self profiles at: aProfile) value
]

{ #category : #accessing }
TKTConfiguration class >> profile: aProfile during: aBlock [
	^ self value: (self value profiles at: aProfile) value during: aBlock
]

{ #category : #accessing }
TKTConfiguration class >> profiles [
	^ {(#profile -> #development).
	(#development
		-> [ {(#initialize
				-> [ TKTDebugger enable.
					self runner start ]).
			(#runner -> TKTCommonQueueWorkerPool createDefault).
			(#poolWorkerProcess -> TKTDebuggWorkerProcess).
			(#process -> TKTRawProcess).
			(#errorHandler -> TKTDebuggerExceptionHandler).
			(#processProvider -> TKTTaskItProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary ]).
	(#production
		-> [ {(#initialize
				-> [ TKTDebugger disable.
					self runner start ]).
			(#runner -> TKTCommonQueueWorkerPool createDefault).
			(#poolWorkerProcess -> TKTWorkerProcess).
			(#process -> Process).
			(#errorHandler -> TKTExceptionHandler).
			(#processProvider -> TKTPharoProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary ]).
	(#test
		-> [ {(#initialize
				-> [ TKTDebugger disable.
					self runner start ]).
			(#runner -> TKTCommonQueueWorkerPool createDefault).
			(#poolWorkerProcess -> TKTWorkerProcess).
			(#process -> Process).
			(#errorHandler -> TKTExceptionHandler).
			(#processProvider -> TKTTaskItProcessProvider new).
			(#serviceManager -> TKTServiceManager new)} asDictionary ])} asDictionary
]

{ #category : #accessing }
TKTConfiguration class >> runner [
	^ self optionAt: #runner
]

{ #category : #accessing }
TKTConfiguration class >> runner: aRunner during: aBlock [
	^ self optionAt: #runner value: aRunner during: aBlock
]

{ #category : #'as yet unclassified' }
TKTConfiguration class >> serviceManager [
	^ self optionAt: #serviceManager
]

{ #category : #accessing }
TKTConfiguration >> default [
	| configuration |
	^ value
		ifNil: [ configuration := self class profiles.
			value := (configuration at: (configuration at: #profile)) value.
			(value at: #initialize) value.
			value ]
]

{ #category : #accessing }
TKTConfiguration >> value: aValue [
	value := aValue
]
