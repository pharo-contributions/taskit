Class {
	#name : #TKTProject,
	#superclass : #Object,
	#instVars : [
		'name',
		'url',
		'version',
		'kind'
	],
	#category : #TaskItForkIt
}

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
