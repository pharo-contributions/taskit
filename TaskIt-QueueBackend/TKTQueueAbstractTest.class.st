Class {
	#name : #TKTQueueAbstractTest,
	#superclass : #TestCase,
	#instVars : [
		'connection'
	],
	#category : #'TaskIt-QueueBackend-Tests'
}

{ #category : #'as yet unclassified' }
TKTQueueAbstractTest >> broadcastQueueName [

	^ '/exchange/broadcast-test'
]

{ #category : #running }
TKTQueueAbstractTest >> createBroadcastExchange [

	| exchangeName |
	
	exchangeName := (self broadcastQueueName splitOn: '/') at:3.

	ZnEasy client
		url: 'http://test:test@192.168.103.52:15672/api/exchanges/%2F/' , exchangeName;
		delete.

	ZnEasy client
		url: 'http://test:test@192.168.103.52:15672/api/exchanges/%2F/' , exchangeName;
		contents: '{"type":"fanout","durable":true}';
		contentType: 'application/json';
		put.

]

{ #category : #running }
TKTQueueAbstractTest >> emptyQueues [

	ZnEasy client
		url: 'http://test:test@192.168.103.52:15672/api/queues/%2F/' , self roundRobinQueueName;
		delete.

	ZnEasy client
		url: 'http://test:test@192.168.103.52:15672/api/queues/%2F/' , self masterQueueName;
		delete.

	ZnEasy client
		url: 'http://test:test@192.168.103.52:15672/api/queues/%2F/' , self masterQueueName;
		contents: '{"durable":true}';
		contentType: 'application/json';
		put.

]

{ #category : #'as yet unclassified' }
TKTQueueAbstractTest >> masterForTest [

 	| newMaster |

	newMaster := TKTQueueBackendRunner new.

	newMaster configuration
		host: '192.168.103.52';
		port: 61613;
		login: 'test';
	 	passcode: 'test';
		roundRobinQueue: self roundRobinQueueName;
		broadcastQueue: self broadcastQueueName;
		masterQueue: self masterQueueName.	
		
	^ newMaster
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
TKTQueueAbstractTest >> runCaseManaged [ 

	^ self runCase
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

	self createBroadcastExchange.	
	self emptyQueues.
	
	connection := StampClient new.
	connection host: '192.168.103.52'.
	connection login: 'test'.
	connection passcode: 'test'.
	connection open.
]

{ #category : #'as yet unclassified' }
TKTQueueAbstractTest >> slaveForTest [

 	| newSlave |

	newSlave := TKTSlaveRunner new.

	newSlave configuration
		host: '192.168.103.52';
		port: 61613;
		login: 'test';
	 	passcode: 'test';
		roundRobinQueue: self roundRobinQueueName;
		broadcastQueue: self broadcastQueueName;
		masterQueue: self masterQueueName.	
		
	^ newSlave
]

{ #category : #running }
TKTQueueAbstractTest >> tearDown [

	connection ifNotNil:#close.
	
	ZnEasy client
		url: 'http://test:test@192.168.103.52:15672/api/queues/%2F/' , self roundRobinQueueName;
		delete.

	ZnEasy client
		url: 'http://test:test@192.168.103.52:15672/api/queues/%2F/' , self masterQueueName;
		delete.
	
	super tearDown.
	
]

{ #category : #testing }
TKTQueueAbstractTest >> waitEventOn: aQueueName during: aBlock timeout: timeout [ 
	
	|msg|

	[aBlock value.

	connection timeout: timeout asSeconds.
	connection subscribeTo: aQueueName.
		
	msg := connection readMessage.
	
	^ FLMaterializer materializeFromByteArray: msg body.] ensure: [ connection close ]

]
