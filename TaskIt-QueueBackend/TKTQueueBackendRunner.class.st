Class {
	#name : #TKTQueueBackendRunner,
	#superclass : #TKTRunner,
	#instVars : [
		'connection',
		'listeningProcess',
		'subscription',
		'tasks',
		'configuration',
		'futures'
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

	[
		event := FLMaterializer materializeFromByteArray: msg body.
		event processEvent: self.
		connection write: msg ackFrame	
	]	on: Error 
		do: [ :e | 
			e debug.
			connection write: msg nackFrame ]
]

{ #category : #'future-stream' }
TKTQueueBackendRunner >> futureStream: aTask [ 
	| execution |
	execution := aTask asTask configureTaskExecution: TKTFutureStreamExecution new with: self.
	self scheduleTaskExecution: execution.
	^ execution future
]

{ #category : #initialization }
TKTQueueBackendRunner >> initialize [

	super initialize.
	connection := StampClient new.
	futures := WeakValueDictionary new.
	tasks := WeakKeyDictionary new.
	
	configuration := TKTQueueConfiguration default.
]

{ #category : #initialization }
TKTQueueBackendRunner >> notifyFailure: uuid exception: exception [

	self task: uuid ifPresent: [ :t | t resultError: exception ]
	
]

{ #category : #initialization }
TKTQueueBackendRunner >> notifyTask: uuid returnValue: value [
	
	self task: uuid ifPresent: [ :t | t resultOk: value ]

]

{ #category : #initialization }
TKTQueueBackendRunner >> processMessage [
	
	| msg |
	
	[
		msg := connection readMessage.
		self doProcessMessage: msg.
	]on: ConnectionTimedOut, ZnIncomplete do: [  ]
]

{ #category : #private }
TKTQueueBackendRunner >> putTask: aTaskExecution at: uuid [

	futures at: uuid put: aTaskExecution future.
	tasks at: aTaskExecution future put: aTaskExecution
]

{ #category : #initialization }
TKTQueueBackendRunner >> scheduleTaskExecution: aTaskExecution [

	| uuid frame event queueName |
	uuid := UUID new.
	event := TKTExecuteTask new 
		uuid: uuid;
		valuable: aTaskExecution task valuable.

	queueName := aTaskExecution isBroadcast 
		ifFalse: [ self configuration roundRobinQueueName ]
		ifTrue: [ self configuration broadcastQueueName ].

	(frame := connection newSendFrameTo: queueName)
		bytes: (ByteArray streamContents: [:s | FLSerializer serialize: event on: s]).
		
	connection write: frame.

	self putTask: aTaskExecution at: uuid
]

{ #category : #initialization }
TKTQueueBackendRunner >> start [ 
	
	self configuration configureConnection: connection.
	connection open.
	
	subscription := connection newSubscriptionTo: self configuration masterQueueName.

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

{ #category : #private }
TKTQueueBackendRunner >> task: uuid ifPresent: aBlock [

	| task future |

	future := futures at: uuid ifAbsent: [ ^ self ].	
	task := tasks at: future ifAbsent: [ ^ self ].
	(task isBroadcast not and: [task isFinished]) ifTrue: [ ^ self ].

	^ aBlock value: task.
]
