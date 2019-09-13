Class {
	#name : #TKTSlaveRunner,
	#superclass : #Object,
	#instVars : [
		'connection',
		'subscription',
		'listeningProcess',
		'configuration',
		'subscriptionBroadcast',
		'heartbeatProcess'
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

{ #category : #'start-stop' }
TKTSlaveRunner >> doConfigure [
	configuration configureConnection: connection.
	connection open.
	self subscribeInput.
	self subscribeBroadcast.
	self startHeartbeat
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

{ #category : #'start-stop' }
TKTSlaveRunner >> heartbeat [

	self sendEvent: TKTHeartbeatEvent to: self configuration heartbeatQueueName
]

{ #category : #initialization }
TKTSlaveRunner >> initialize [ 
	
	connection := StampClient new.
	configuration := TKTQueueConfiguration default
]

{ #category : #'start-stop' }
TKTSlaveRunner >> processMessage [
	
	| msg |
	
	"Process a message, if the connection gives timeout it has to retry. As it is part of the protocol"
	
	[	msg := connection readMessage.
		self doProcessMessage: msg.
	]on: ConnectionTimedOut do: [  ]
]

{ #category : #'start-stop' }
TKTSlaveRunner >> sendEvent: anEvent to: queueName [ 

	| frame bytes |

	bytes := ByteArray
		streamContents: [ :s | FLSerializer serialize: anEvent on: s ].
	(frame := connection newSendFrameTo: queueName)
		bytes: bytes.
		
	connection write: frame
]

{ #category : #'start-stop' }
TKTSlaveRunner >> sendToMaster: anEvent [

	self sendEvent: anEvent to: self configuration masterQueueName
]

{ #category : #'start-stop' }
TKTSlaveRunner >> start [
	self doConfigure.
	listeningProcess := [ [ self processMessage ] repeat ] newProcess.
	listeningProcess resume
]

{ #category : #'start-stop' }
TKTSlaveRunner >> startBlocking [

	self doConfigure.	
	
	[[self processMessage] repeat] on: Exception do: [ :e |
		e debug.
		Smalltalk snapshot: false andQuit: true ]
]

{ #category : #'start-stop' }
TKTSlaveRunner >> startHeartbeat [
	
	heartbeatProcess := [ [self heartbeat. 20 seconds wait] repeat ] newProcess.
	heartbeatProcess resume.

]

{ #category : #'start-stop' }
TKTSlaveRunner >> stop [
	
	listeningProcess ifNotNil: #suspend.
	listeningProcess := nil.
	
	heartbeatProcess ifNotNil: #suspend.
	heartbeatProcess := nil.
	
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
