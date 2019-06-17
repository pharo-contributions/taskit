Class {
	#name : #TKTProject,
	#superclass : #Object,
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
		repository: 'github://sbragagnolo/taskit';
		yourself
]

{ #category : #'as yet unclassified' }
TKTProject class >> moose [
	^ TKTProject new
		name: #Moose;
		kind: #BaselineOf;
		repository: 'github://moosetechnology/Moose:development';
		yourself
]

{ #category : #'as yet unclassified' }
TKTProject class >> taskit [
	^ TKTProject new
		name: #TaskIt;
		kind: #BaselineOf;
		repository: 'github://sbragagnolo/taskit';
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

{ #category : #accessing }
TKTProject >> kind: aString [ 
	kind := aString
]

{ #category : #accesisng }
TKTProject >> name: aString [ 
	name := aString
]

{ #category : #accessing }
TKTProject >> repository: aString [
	url := aString
]
