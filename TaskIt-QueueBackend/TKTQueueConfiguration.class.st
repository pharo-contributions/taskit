Class {
	#name : #TKTQueueConfiguration,
	#superclass : #Object,
	#instVars : [
		'roundRobinQueueName',
		'masterQueueName',
		'host',
		'login',
		'passcode',
		'port'
	],
	#category : #'TaskIt-QueueBackend'
}

{ #category : #'as yet unclassified' }
TKTQueueConfiguration class >> default [

	^ self new
		host: 'localhost';
		port: 61613;
		login: 'guest';
	 	passcode: 'guest';
		roundRobinQueue: 'roundRobin';
		masterQueue: 'master';
		yourself.

]

{ #category : #configuring }
TKTQueueConfiguration >> configureConnection: aStampClient [ 
	
	aStampClient 
		host: host;
		login: login;
		passcode: passcode;
		port: port
]

{ #category : #accessing }
TKTQueueConfiguration >> host: aString [ 
	
	host := aString
]

{ #category : #accessing }
TKTQueueConfiguration >> login: aString [ 
	
	login := aString
]

{ #category : #accessing }
TKTQueueConfiguration >> masterQueue: aString [ 
	
	masterQueueName := aString
]

{ #category : #accessing }
TKTQueueConfiguration >> masterQueueName [
	
	^ masterQueueName
]

{ #category : #accessing }
TKTQueueConfiguration >> passcode: aString [ 
	
	passcode := aString
]

{ #category : #accessing }
TKTQueueConfiguration >> port: anInteger [ 
	
	port := anInteger
]

{ #category : #accessing }
TKTQueueConfiguration >> roundRobinQueue: aString [ 
	
	roundRobinQueueName := aString
]

{ #category : #accessors }
TKTQueueConfiguration >> roundRobinQueueName [
	^ roundRobinQueueName
]
