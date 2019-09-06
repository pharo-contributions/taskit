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
TKTOutgoingTasksService >> cleanUpImageToStart [
	self stop.
]

{ #category : #registry }
TKTOutgoingTasksService >> deployFutureResult: valueId [
	| futureExecution |
	futureExecution := futures at: valueId second.
	[ [ futureExecution deployValue: valueId first.
	futures removeKey: valueId second ]
		on: Error
		do: [ :e | 
			futureExecution future
				deployFailure:
					(Error new
						messageText:
							'Error on processing response. TKTOutgoingTasksService >>#deployFutureResult: '
								, e messageText) ] ]
		ensure: [ top noteTaskHasFinished: futureExecution ]
]

{ #category : #registry }
TKTOutgoingTasksService >> ensureIsWorking [
	( server isRunning & server isListening )
		ifFalse: [ server start ].
	self assert: server isRunning & server isListening
]

{ #category : #registry }
TKTOutgoingTasksService >> filterToStillNeededTasks: aCollectionOfTaskExecutions [
	^ aCollectionOfTaskExecutions
		select: [ :rte | futures includesKey: rte id ]
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
		map: 'deployFutureResult' to: #deployFutureResult:;
		map: 'requestTask' to: #requestTask:.
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
	weakRegistry add: aTaskExecution
]

{ #category : #registry }
TKTOutgoingTasksService >> requestTask: aBackendHash [
	top requestTaskForBackend: aBackendHash.
	^ true.
]

{ #category : #registry }
TKTOutgoingTasksService >> start [
	^ server
		ifNil: [ server := ZnServer on: 0.
			server maximumEntitySize: (30 *1024*1024).  "30Mb"
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
	self ensureIsWorking. 
	^ server localUrl
]
