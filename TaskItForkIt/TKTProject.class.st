"
A project refers to a metacello available endpoint. This can be a baseline or a configuration. 
"
Class {
	#name : #TKTProject,
	#superclass : #Object,
	#traits : 'TEquality',
	#classTraits : 'TEquality classTrait',
	#instVars : [
		'name',
		'url',
		'version',
		'kind'
	],
	#category : #'TaskItForkIt-ImageBuilding'
}

{ #category : #'as yet unclassified' }
TKTProject class >> baselineTests [
	^ TKTProject new
		name: #BaselineTest;
		kind: #BaselineOf;
		repository: 'github://sbragagnolo/BaselineTest';
		yourself
]

{ #category : #'as yet unclassified' }
TKTProject class >> forkit [
	^ TKTProject new
		name: #ForkIt;
		kind: #BaselineOf;
		repository: 'https://github.com/sbragagnolo/taskit:ForkIt';
		yourself
]

{ #category : #'as yet unclassified' }
TKTProject class >> moose [
	^ TKTProject new
		name: #Moose;
		kind: #BaselineOf;
		repository: 'https://github.com/moosetechnology/Moose:development';
		yourself
]

{ #category : #'as yet unclassified' }
TKTProject class >> taskit [
	^ TKTProject new
		name: #TaskIt;
		kind: #BaselineOf;
		repository: 'https://github.com/sbragagnolo/taskit';
		yourself
]

{ #category : #accesisng }
TKTProject >> archetypeName [
	^ name,( url copyReplaceAll: '/' with:'') copyReplaceAll:':' with: '_' asString
]

{ #category : #'deployingas yet unclassified' }
TKTProject >> deployIn: aTKTDeployed [
	| s future |
	future := aTKTDeployed
		install: url asString
		configurationOrBaselineName: kind asString , name.
	future synchronizeTimeout: 15 minutes.
]

{ #category : #deploy }
TKTProject >> deployIn: aTKTDeployed using: aTKTDeployer [
	^ self deployIn: aTKTDeployed
]

{ #category : #accessing }
TKTProject >> kind: aString [
	self
		assert: ({#BaselineOf . #ConfigurationOf} includes: aString asSymbol).
	kind := aString
]

{ #category : #naming }
TKTProject >> name [
	^ name
]

{ #category : #accesisng }
TKTProject >> name: aString [ 
	name := aString
]

{ #category : #accessing }
TKTProject >> repository: aString [
	url := aString
]

{ #category : #accessing }
TKTProject >> url [
	^ url
]
