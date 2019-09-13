Class {
	#name : #TKTSlaveRunner,
	#superclass : #Object,
	#instVars : [
		'connection',
		'subscription',
		'listeningProcess',
		'configuration',
		'subscriptionBroadcast'
	],
	#category : #'TaskIt-QueueBackend'
}

{ #category : #'as yet unclassified' }
TKTSlaveRunner class >> default [

	| slave |
	slave := TKTSlaveRunner new.

	^ slave
		yourself.

]

{ #category : #'as yet unclassified' }
TKTSlaveRunner class >> startBlocking [

	self default startBlocking.
]

{ #category : #subscribing }
TKTSlaveRunner >> configuration [ 
	
	^ configuration
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

{ #category : #initialization }
TKTSlaveRunner >> initialize [ 
	
	connection := StampClient new.
	configuration := TKTQueueConfiguration default
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
TKTSlaveRunner >> sendToMaster: anEvent [
	| frame bytes |
	bytes := ByteArray
		streamContents: [ :s | FLSerializer serialize: anEvent on: s ].
	(frame := connection newSendFrameTo: configuration masterQueueName)
		bytes: bytes.
		
	connection write: frame
]

{ #category : #'start-stop' }
TKTSlaveRunner >> start [
	
	configuration configureConnection: connection.
	connection open.
	
	self subscribeInput.
	self subscribeBroadcast.
	
	listeningProcess := [ [self processMessage] repeat ] newProcess.
	listeningProcess resume.
]

{ #category : #'start-stop' }
TKTSlaveRunner >> startBlocking [
	
	configuration configureConnection: connection.
	connection open.
	
	self subscribeInput.
	self subscribeBroadcast.
	
	[[self processMessage] repeat] on: Exception do: [ Smalltalk snapshot: false andQuit: true ]
]

{ #category : #'start-stop' }
TKTSlaveRunner >> stop [
	
	listeningProcess ifNotNil: #suspend.
	listeningProcess := nil.
	
	connection close.
]

{ #category : #subscribing }
TKTSlaveRunner >> subscribeBroadcast [
	
	subscriptionBroadcast := connection newSubscriptionTo: self configuration broadcastQueueName.
	subscriptionBroadcast 
		clientIndividualAck;
		prefetchCount: 1.
	
	connection write: subscriptionBroadcast subscribeFrame

]

{ #category : #subscribing }
TKTSlaveRunner >> subscribeInput [
	
	subscription := connection newSubscriptionTo: configuration roundRobinQueueName.

	subscription 
		clientIndividualAck;
		prefetchCount: 1.
	
	connection write: subscription subscribeFrame

]
