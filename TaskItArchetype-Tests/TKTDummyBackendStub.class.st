"
Just a dummy that ensures the dependance on the backend ,.
"
Class {
	#name : #TKTDummyBackendStub,
	#superclass : #TKTSystemAdapter,
	#instVars : [
		'commandCalled'
	],
	#category : #'TaskItArchetype-Tests'
}

{ #category : #folder }
TKTDummyBackendStub >> command: aCommand for: aDeployed [
	commandCalled := commandCalled + 1 .
	^ super command: aCommand for: aDeployed
]

{ #category : #folder }
TKTDummyBackendStub >> commandCalled [
	^ commandCalled
]

{ #category : #folder }
TKTDummyBackendStub >> initialize [
	super initialize.
	commandCalled := 0
]
