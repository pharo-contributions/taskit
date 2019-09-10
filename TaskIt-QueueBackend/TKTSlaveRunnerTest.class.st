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
	slave := self slaveForTest
]

{ #category : #running }
TKTSlaveRunnerTest >> tearDown [

	slave ifNotNil:#stop.
	super setUp.
	
]

{ #category : #tests }
TKTSlaveRunnerTest >> testSendingATask [

	| event |

	event := TKTExecuteTask new
		uuid: '23';
		valuable: [ 2 + 40 ];
		yourself.
		 
	self sendEvent: event to: self roundRobinQueueName.

]
