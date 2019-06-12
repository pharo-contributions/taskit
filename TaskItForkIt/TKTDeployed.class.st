Class {
	#name : #TKTDeployed,
	#superclass : #Object,
	#instVars : [
		'location',
		'archetype'
	],
	#category : #TaskItForkIt
}

{ #category : #accessing }
TKTDeployed >> changesFile [
	^ location / 'Pharo.changes'
]

{ #category : #accessing }
TKTDeployed >> command [
	^ self vmBinary command
		option: '--headless';
		option: self imageFile fullName;
		yourself
]

{ #category : #accessing }
TKTDeployed >> imageFile [
	^ location / #'Pharo.image'
]

{ #category : #accessing }
TKTDeployed >> initializeWithLocation: aLocation andArchetype: anArquetype [
	location := aLocation.
	archetype := anArquetype.
	archetype dependancies do: [ :d | d deployIn: self ]
]

{ #category : #accessing }
TKTDeployed >> pharoScript [
	^ location / 'pharo'
]

{ #category : #accessing }
TKTDeployed >> pharoUiScript [
	^ location / 'pharo-ui'
]

{ #category : #accessing }
TKTDeployed >> sourcesFile [

	^ location entries
		detect: [ :f | 
			(f basename beginsWith: (archetype version readStream upTo:$-))
				and: [ f basename endsWith: '.sources' ] ]
]

{ #category : #accessing }
TKTDeployed >> vm [
	^ location / 'pharo-vm'
]

{ #category : #accessing }
TKTDeployed >> vmBinary [
	| ref |
	ref := OSPlatform current isMacOS
		ifTrue: [ self vmFolder / 'Pharo.app' / #Contents / #MacOS / #Pharo ]
		ifFalse: [ self vmFolder / #pharo ].
	self assert: ref isFile.
	^ ref
]

{ #category : #'accessingas yet unclassified' }
TKTDeployed >> vmFolder [
	^ location / #'pharo-vm' 
]
