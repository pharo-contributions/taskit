"
This class is here for dealing with the registry of futures, for remote executions 
"
Class {
	#name : #TKTArchetypedFutureRegistry,
	#superclass : #TKTServerDelegate,
	#instVars : [
		'futures',
		'server',
		'top',
		'weakRegistry'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #registry }
TKTArchetypedFutureRegistry >> amountOfTasksFor: anArchetype [
	^ (weakRegistry , futures collect: [ :t | t archetype = anArchetype ])
		size
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> deployFutureResult: aRequest [
	| valueId |
	valueId := (STONReader on: aRequest entity string readStream) next.
	(futures at: valueId second) deployValue: valueId first.
	futures removeKey: valueId second.
]

{ #category : #accessing }
TKTArchetypedFutureRegistry >> futures [
	^ futures ifNil: [ futures := Dictionary new ]
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> initialize [
	super initialize.
	self
		map: 'registerBackend' to: #registerBackend:;
		map: 'deployFutureResult' to: #deployFutureResult:.
	futures := Dictionary new.
	weakRegistry := WeakSet new
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> register: anArchetypedFuture [
	| id |
	id := UUID new asString.
	self futures at: id put: anArchetypedFuture.
	anArchetypedFuture id: id
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> registerBackend: aRequest [
	| arrayUrlHash |
	arrayUrlHash := (STONReader on: aRequest entity string readStream)
		next.
	top
		noteRemoteWorkerAt: arrayUrlHash first
		forBackendHashed: arrayUrlHash second.
	^ true
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> registerNotDeployable: aTaskExecution [
	weakRegistry add: aTaskExecution.
	
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> start [
	^ server
		ifNil: [ 
			server := ZnSingleThreadedServer on: 0.
			server bindingAddress: NetNameResolver loopBackAddress.
			server delegate: self.
			server start.
			self assert: server isRunning & server isListening 
		]
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> top: aMainRunner [
	top := aMainRunner
]

{ #category : #registry }
TKTArchetypedFutureRegistry >> url [
	self assert: server isRunning & server isListening.
	^ server localUrl
]
