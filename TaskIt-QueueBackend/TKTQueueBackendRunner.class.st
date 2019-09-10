Class {
	#name : #TKTQueueBackendRunner,
	#superclass : #TKTRunner,
	#instVars : [
		'connection',
		'listeningProcess',
		'subscription',
		'tasks',
		'configuration'
	],
	#category : #'TaskIt-QueueBackend'
}

{ #category : #accessing }
TKTQueueBackendRunner class >> default [

	^ self new

]

{ #category : #configuration }
TKTQueueBackendRunner >> configuration [
	^ configuration
]

{ #category : #initialization }
TKTQueueBackendRunner >> doProcessMessage: msg [ 

	| event |

"	[
"		event := FLMaterializer materializeFromByteArray: msg body.
		event processEvent: self.
		connection write: msg ackFrame	
"	]	on: Error 
		do: [ :e | 
			e debug.
			connection write: msg nackFrame ]"
]

{ #category : #initialization }
TKTQueueBackendRunner >> initialize [

	super initialize.
	connection := StampClient new.
	tasks := Dictionary new.
	configuration := TKTQueueConfiguration default.
]

{ #category : #initialization }
TKTQueueBackendRunner >> notifyFailure: uuid exception: exception [
	| task |
	task := tasks at: uuid ifAbsent: [ ^ self ].
	task isFinished
		ifTrue: [ ^ self ].
	task resultError: exception.
	tasks removeKey: uuid
]

{ #category : #initialization }
TKTQueueBackendRunner >> notifyTask: uuid returnValue: value [

	| task |

	task := tasks at:uuid ifAbsent: [ ^ self ].
	task isFinished ifTrue: [ ^ self ].
	task resultOk: value.
	
	tasks removeKey: uuid 
]

{ #category : #initialization }
TKTQueueBackendRunner >> processMessage [
	
	| msg |
	
	[
		msg := connection readMessage.
		self doProcessMessage: msg.
	]on: ConnectionTimedOut, ZnIncomplete do: [  ]
]

{ #category : #initialization }
TKTQueueBackendRunner >> scheduleTaskExecution: aTaskExecution [

	| uuid frame event |
	uuid := UUID new.
	event := TKTExecuteTask new 
		uuid: uuid;
		valuable: aTaskExecution task valuable.

	(frame := connection newSendFrameTo: configuration roundRobinQueueName)
		bytes: (ByteArray streamContents: [:s | FLSerializer serialize: event on: s]).
		
	connection write: frame.

	tasks at: uuid put: aTaskExecution.
]

{ #category : #initialization }
TKTQueueBackendRunner >> start [ 
	
	configuration configureConnection: connection.
	connection open.
	
	subscription := connection newSubscriptionTo: configuration masterQueueName.

	subscription 
		clientIndividualAck;
		prefetchCount: 1.
	
	connection write: subscription subscribeFrame.
	
	listeningProcess := [ [self processMessage] repeat ] newProcess.
	listeningProcess resume.
]

{ #category : #initialization }
TKTQueueBackendRunner >> stop [ 

	[connection close] on: Error do:[].
	listeningProcess ifNotNil: #suspend.
	listeningProcess := nil.
]
