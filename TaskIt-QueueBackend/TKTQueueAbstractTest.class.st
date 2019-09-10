Class {
	#name : #TKTQueueAbstractTest,
	#superclass : #TestCase,
	#instVars : [
		'connection'
	],
	#category : #'TaskIt-QueueBackend-Tests'
}

{ #category : #running }
TKTQueueAbstractTest >> emptyQueues [

	ZnEasy client
		url: 'http://guest:guest@localhost:15672/api/queues/%2F/' , self roundRobinQueueName;
		delete.

	ZnEasy client
		url: 'http://guest:guest@localhost:15672/api/queues/%2F/' , self masterQueueName;
		delete.

]

{ #category : #'as yet unclassified' }
TKTQueueAbstractTest >> masterQueueName [

	^ 'master-test'
]

{ #category : #'as yet unclassified' }
TKTQueueAbstractTest >> roundRobinQueueName [

	^ 'roundRobin-test'
]

{ #category : #testing }
TKTQueueAbstractTest >> sendEvent: anEvent to: aQueueName [ 

	| frame |

	(frame := connection newSendFrameTo: aQueueName)
		bytes: (ByteArray streamContents: [:s | FLSerializer serialize: anEvent on: s]).
		
	connection write: frame.

]

{ #category : #running }
TKTQueueAbstractTest >> setUp [

	super setUp.
	
	self emptyQueues.
	
	connection := StampClient new.
	connection open.
]

{ #category : #'as yet unclassified' }
TKTQueueAbstractTest >> slaveForTest [

	^ TKTSlaveRunner new
		host: 'localhost';
		port: 61613;
		login: 'guest';
	 	passcode: 'guest';
		roundRobinQueue: self roundRobinQueueName;
		masterQueue: self masterQueueName;
		yourself.
	
]

{ #category : #running }
TKTQueueAbstractTest >> tearDown [

	connection ifNotNil:#close.
	super setUp.
	
]

{ #category : #testing }
TKTQueueAbstractTest >> waitEventOn: aQueueName during: aBlock timeout: timeout [ 

	| msg |
	connection subscribeTo: aQueueName.
	connection timeout: timeout asSeconds.
	
	aBlock value.
	
	msg := connection readMessage.
	
	^ FLMaterializer materializeFromByteArray: msg body.

]
