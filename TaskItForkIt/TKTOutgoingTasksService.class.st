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
TKTOutgoingTasksService >> deployFutureResult: valueId [

	[ (futures at: valueId second) deployValue: valueId first.
	futures removeKey: valueId second ]
		on: Error
		do: [ :e | 
			(futures at: valueId second) future
				deployFailure:
					(Error new
						messageText:
							'Error on processing response. TKTOutgoingTasksService >>#deployFutureResult: '
								, e messageText) ]
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
TKTOutgoingTasksService >> registerBackend: arrayUrlHash [
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
		ifNil: [ server := ZnServer on: 0.
			server bindingAddress: NetNameResolver loopBackAddress.
			server delegate: self.
			server start.
			self assert: server isRunning & server isListening ]
]

{ #category : #registry }
TKTOutgoingTasksService >> stop [
	^ server
		ifNotNil: [ server stop.
			server := nil ]
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
