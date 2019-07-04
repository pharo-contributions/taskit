Class {
	#name : #TKTProjectBasicTest,
	#superclass : #TestCase,
	#instVars : [
		'url',
		'installing'
	],
	#category : #'TaskItForkIt-Tests'
}

{ #category : #testing }
TKTProjectBasicTest >> ensureIcebergRemoteTypeSelector: aString [ 

]

{ #category : #tests }
TKTProjectBasicTest >> install: aURl configurationOrBaselineName: aConfOrBaseline [
	
	url := aURl.
	installing := aConfOrBaseline
]

{ #category : #polymorfism }
TKTProjectBasicTest >> synchronizeTimeout: aDuration [ 
	^ true
]

{ #category : #tests }
TKTProjectBasicTest >> testBaselineProjectIsAcceptedAndInstalled [
	TKTProject moose deployIn: self.
	self assert: url equals: TKTProject moose url.
	self assert: installing equals: #BaselineOfMoose
]

{ #category : #tests }
TKTProjectBasicTest >> testConfigurationProjectIsAcceptedAndInstalled [
	(TKTProject moose
		kind: #ConfigurationOf;
		yourself) deployIn: self.
	self assert: url equals: TKTProject moose url.
	self assert: installing equals: #ConfigurationOfMoose
]

{ #category : #tests }
TKTProjectBasicTest >> testNonConfigurationNorBaselineFails [
	self
		should: [ (TKTProject moose
				kind: #WhateverElse;
				yourself) deployIn: self ]
		raise: Error
]
