Class {
	#name : #TKTServiceTests,
	#superclass : #TKTTestCase,
	#instVars : [
		'service'
	],
	#category : 'TaskIt-Tests-Services'
}

{ #category : #'as yet unclassified' }
TKTServiceTests >> tearDown [

	super tearDown.
	(service notNil and: [service isRunning]) ifTrue: [
		(service stop) waitForCompletion: 1 second ]
]

{ #category : #tests }
TKTServiceTests >> testServiceIsKilledAfterStop [

	service := TKTParameterizableService new.
	service name: 'test service'.
	service start.
	(service stop) waitForCompletion: 2 second.
	
	self deny: service isRunning.
]

{ #category : #'as yet unclassified' }
TKTServiceTests >> testServiceShouldHaveAName [

	self should: [TKTService new start] raise: Error
]
