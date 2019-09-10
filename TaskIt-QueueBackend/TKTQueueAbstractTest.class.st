Class {
	#name : #TKTQueueAbstractTest,
	#superclass : #TestCase,
	#instVars : [
		'connection'
	],
	#category : #'TaskIt-QueueBackend-Tests'
}

{ #category : #'as yet unclassified' }
TKTQueueAbstractTest >> masterQueueName [

	^ 'master-test'
]

{ #category : #'as yet unclassified' }
TKTQueueAbstractTest >> roundRobinQueueName [

	^ 'roundRobin-test'
]

{ #category : #running }
TKTQueueAbstractTest >> setUp [

	super setUp.
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
