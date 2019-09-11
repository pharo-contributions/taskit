Class {
	#name : #TKTSlaveRunnerTest,
	#superclass : #TKTQueueAbstractTest,
	#instVars : [
		'slave'
	],
	#category : #'TaskIt-QueueBackend-Tests'
}

{ #category : #running }
TKTSlaveRunnerTest >> setUp [
	
	super setUp.
	slave := self slaveForTest.
	slave start
]

{ #category : #running }
TKTSlaveRunnerTest >> tearDown [

	slave ifNotNil:#stop.
	super setUp.
	
]

{ #category : #tests }
TKTSlaveRunnerTest >> testSendingATask [
	| event responseEvent |
	event := TKTExecuteTask new
		uuid: '23';
		valuable: [ 2 + 40 ];
		yourself.

	responseEvent := self
		waitEventOn: self masterQueueName
		during: [ self sendEvent: event to: self roundRobinQueueName ]
		timeout: 10 seconds.
		
	self assert: responseEvent value equals: 42
]

{ #category : #tests }
TKTSlaveRunnerTest >> testSendingATaskToBroadcast [

	| event responseEvent |

	event := TKTExecuteTask new
		uuid: '23';
		valuable: [ 2 + 40 ];
		yourself.

	responseEvent := self
		waitEventOn: self masterQueueName
		during: [ self sendEvent: event to: self broadcastQueueName ]
		timeout: 10 seconds.
		
	self assert: responseEvent value equals: 42
]

{ #category : #tests }
TKTSlaveRunnerTest >> testSendingAnErrorTask [
	| event responseEvent |
	event := TKTExecuteTask new
		uuid: '23';
		valuable: (MessageSend receiver: 1 selector: #/ argument: 0);
		yourself.

	responseEvent := self
		waitEventOn: self masterQueueName
		during: [ self sendEvent: event to: self roundRobinQueueName ]
		timeout: 10 seconds.
		
	self assert: responseEvent exception class equals: ZeroDivide

]
