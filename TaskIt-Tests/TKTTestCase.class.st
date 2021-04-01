"
It only defines a teardown for ensure that the current pool is properly clean after executing tests.
"
Class {
	#name : #TKTTestCase,
	#superclass : #ParametrizedTestCase,
	#category : #'TaskIt-Tests-Kernel'
}

{ #category : #private }
TKTTestCase class >> isAbstract [

	^ self name = #TKTTestCase
]

{ #category : #running }
TKTTestCase >> garbageCollectAndWait [
	5
		timesRepeat: [ Smalltalk garbageCollect.
			100 milliSeconds wait ].
	1 second wait.
	5
		timesRepeat: [ Smalltalk garbageCollect.
			100 milliSeconds wait ].
	1 second wait.
	5
		timesRepeat: [ Smalltalk garbageCollect.
			100 milliSeconds wait ]
]

{ #category : #running }
TKTTestCase >> runCaseManaged [
	^ self runCase
]

{ #category : #running }
TKTTestCase >> setUp [
	super setUp.
	TKTConfiguration
		resetSoleInstance;
		profileNamed: #test.
]

{ #category : #running }
TKTTestCase >> tearDown [

	TKTConfiguration resetSoleInstance.
	super tearDown	
]
