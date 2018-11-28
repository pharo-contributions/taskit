"
It only defines a teardown for ensure that the current pool is properly clean after executing tests.
"
Class {
	#name : #TKTTestCase,
	#superclass : #TestCase,
	#category : 'TaskIt-Tests-Kernel'
}

{ #category : #running }
TKTTestCase >> setUp [
	super setUp.
	TKTConfiguration
		resetSoleInstance;
		profile: #test
]

{ #category : #running }
TKTTestCase >> tearDown [
	super tearDown.
	TKTConfiguration resetSoleInstance
]
