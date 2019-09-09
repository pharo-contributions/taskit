Class {
	#name : #TKTSlaveRunner,
	#superclass : #Object,
	#instVars : [
		'connection',
		'inputQueueName',
		'answerQueueName',
		'subscription',
		'listeningProcess'
	],
	#category : #'TaskIt-QueueBackend'
}

{ #category : #'as yet unclassified' }
TKTSlaveRunner class >> runDefault [

	| slave |
	slave := TKTSlaveRunner new.

	slave
		host: 'localhost';
		port: 61613;
		login: 'guest';
	 	passcode: 'guest';
		inputQueue: 'singleTask';
		answerQueue: 'singleTask-response';
		startBlocking.

]

{ #category : #accessing }
TKTSlaveRunner >> answerQueue: aString [ 
	
	answerQueueName := aString
]

{ #category : #processing }
TKTSlaveRunner >> doProcessMessage: msg [ 

	| event |

	[
		event := FLMaterializer materializeFromByteArray: msg body.
		event processEvent: self.		
		connection write: msg ackFrame	
	]	on: Error 
		do: [ connection write: msg nackFrame ]
]

{ #category : #accessing }
TKTSlaveRunner >> host: aString [ 
	
	connection host: aString
]

{ #category : #initialization }
TKTSlaveRunner >> initialize [ 
	
	connection := StampClient new
]

{ #category : #accessing }
TKTSlaveRunner >> inputQueue: aString [ 
	
	inputQueueName := aString
]

{ #category : #accessing }
TKTSlaveRunner >> login: aString [ 
	
	connection login: aString
]

{ #category : #accessing }
TKTSlaveRunner >> passcode: aString [ 
	
	connection passcode: aString
]

{ #category : #accessing }
TKTSlaveRunner >> port: anInteger [ 
	
	connection port: anInteger
]

{ #category : #'start-stop' }
TKTSlaveRunner >> processMessage [
	
	| msg |
	
	[
		msg := connection readMessage.
		self doProcessMessage: msg.
	]on: ConnectionTimedOut do: [  ]
]

{ #category : #'start-stop' }
TKTSlaveRunner >> responseEvent: anEvent [

	| frame |

	(frame := connection newSendFrameTo: answerQueueName)
		bytes: (ByteArray streamContents: [:s | FLSerializer serialize: anEvent on: s]).
		
	connection write: frame

]

{ #category : #'start-stop' }
TKTSlaveRunner >> start [
	
	connection open.
	self subscribeInput.
	
	listeningProcess := [ [self processMessage] repeat ] fork.
	listeningProcess resume.
]

{ #category : #'start-stop' }
TKTSlaveRunner >> startBlocking [
	
	connection open.
	self subscribeInput.
	
	[self processMessage] repeat
]

{ #category : #'start-stop' }
TKTSlaveRunner >> stop [
	
	listeningProcess ifNotNil: #suspend.
	listeningProcess := nil.
	
	connection close.
]

{ #category : #subscribing }
TKTSlaveRunner >> subscribeInput [
	
	subscription := connection newSubscriptionTo: inputQueueName.

	subscription 
		clientIndividualAck;
		prefetchCount: 1.
	
	connection write: subscription subscribeFrame

]
