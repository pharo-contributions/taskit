"
It only defines a teardown for ensure that the current pool is properly clean after executing tests.
"
Class {
	#name : #TKTTestCase,
	#superclass : #TestCase,
	#category : 'TaskIt-Tests-Kernel'
}

{ #category : #running }
TKTTestCase >> garbageCollectAndWait [
	5
		timesRepeat: [ Smalltalk garbageCollect.
			100 milliSeconds wait ].
	1 second wait.
	5
		timesRepeat: [ Smalltalk garbageCollect.
			100 milliSeconds wait ].
	5
		timesRepeat: [ Smalltalk garbageCollect.
			100 milliSeconds wait ].
	1 second wait.
	5
		timesRepeat: [ Smalltalk garbageCollect.
			100 milliSeconds wait ]
]

{ #category : #running }
TKTTestCase >> setUp [
	super setUp.
	TKTConfiguration
		resetSoleInstance;
		profile: #test.
	self timeLimit: 60 seconds
]

{ #category : #running }
TKTTestCase >> tearDown [
	super tearDown.
	TKTConfiguration resetSoleInstance
]
