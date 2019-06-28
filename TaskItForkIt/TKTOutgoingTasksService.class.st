"
This class is here for dealing with the registry of futures, for remote executions 
"
Class {
	#name : #TKTOutgoingTasksService,
	#superclass : #TKTServerDelegate,
	#instVars : [
		'futures',
		'server',
		'top',
		'weakRegistry'
	],
	#category : #'TaskItForkIt-Worker-Server'
}

{ #category : #registry }
TKTOutgoingTasksService >> amountOfTasksFor: anArchetype [
	^ (weakRegistry , futures collect: [ :t | t archetype = anArchetype ])
		size
]

{ #category : #registry }
TKTOutgoingTasksService >> deployFutureResult: aRequest [
	| valueId |
	self halt.
	valueId := (STONReader on: aRequest entity string readStream) next.
	(futures at: valueId second) deployValue: valueId first.
	futures removeKey: valueId second.
]

{ #category : #accessing }
TKTOutgoingTasksService >> futures [
	^ futures ifNil: [ futures := Dictionary new ]
]

{ #category : #registry }
TKTOutgoingTasksService >> initialize [
	super initialize.
	self
		map: 'registerBackend' to: #registerBackend:;
		map: 'deployFutureResult' to: #deployFutureResult:.
	futures := Dictionary new.
	weakRegistry := WeakSet new
]

{ #category : #registry }
TKTOutgoingTasksService >> register: anArchetypedFuture [
	| id |
	id := UUID new asString.
	self futures at: id put: anArchetypedFuture.
	anArchetypedFuture id: id
]

{ #category : #registry }
TKTOutgoingTasksService >> registerBackend: aRequest [
	| arrayUrlHash |
	arrayUrlHash := (STONReader on: aRequest entity string readStream)
		next.
	top
		noteRemoteWorkerAt: arrayUrlHash first
		forBackendHashed: arrayUrlHash second.
	^ true
]

{ #category : #registry }
TKTOutgoingTasksService >> registerNotDeployable: aTaskExecution [
	weakRegistry add: aTaskExecution.
	
]

{ #category : #registry }
TKTOutgoingTasksService >> start [
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
TKTOutgoingTasksService >> top: aMainRunner [
	top := aMainRunner
]

{ #category : #registry }
TKTOutgoingTasksService >> url [
	self assert: server isRunning & server isListening.
	^ server localUrl
]
