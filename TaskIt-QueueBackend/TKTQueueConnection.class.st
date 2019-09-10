Class {
	#name : #TKTQueueConnection,
	#superclass : #Object,
	#instVars : [
		'connection'
	],
	#category : #'TaskIt-QueueBackend'
}

{ #category : #accessing }
TKTQueueConnection class >> default [ 

	^ self new 
		host: 'localhost';
		port: 61613;
		login: 'guest';
	 	passcode: 'guest';
		roundRobinQueue: 'roundRobin';
		masterQueue: 'master';
		yourself

]
