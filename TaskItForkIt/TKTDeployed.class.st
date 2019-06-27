"
The deployed artifact is a reference to a folder that responds to the bases of a pharo tipical installation. It has pharo / pharoui scripts, a pharo-vm folder and the main image files : image, sources and changes. 
"
Class {
	#name : #TKTDeployed,
	#superclass : #Object,
	#traits : 'TEquality',
	#classTraits : 'TEquality classTrait',
	#instVars : [
		'location',
		'archetype',
		'backend'
	],
	#category : #'TaskItForkIt-ImageBuilding'
}

{ #category : #accessing }
TKTDeployed >> archetype [
	^ archetype
]

{ #category : #accessing }
TKTDeployed >> changesFile [
	^ location / 'Pharo.changes'
]

{ #category : #accessing }
TKTDeployed >> command [
	^ backend command: self pharoScript for: self
]

{ #category : #accessing }
TKTDeployed >> commandUi [
	^ backend command: self pharoUiScript for: self
]

{ #category : #accessing }
TKTDeployed >> eval [
	^ self command option: 'eval'
]

{ #category : #'evalas yet unclassified' }
TKTDeployed >> evalSerialized: aString [
	| output return input |
	output := UUID new asString asFileReference.
	input := '
	| ston | 
	ston := STONWriter on: (''{1}'' asFileReference ensureDelete; writeStream).
	[ ston nextPut: [{2}] value  ] on:Error do: [ :e |  ston nextPut: e ].
	ston close. 
  '
		format:
			{output fullName.
			aString}.
	(self eval argument: input) future synchronizeTimeout: 15 minutes.
	return := (STONReader on: output readStream) next.
	output ensureDelete.
	^ return 
]

{ #category : #accessing }
TKTDeployed >> imageFile [
	^ location / #'Pharo.image'
]

{ #category : #accessing }
TKTDeployed >> initializeWithLocation: aLocation archetype: anArquetype andBackend: aBackend [
	location := aLocation.
	archetype := anArquetype.
	backend := aBackend
]

{ #category : #accessing }
TKTDeployed >> install: url configurationOrBaselineName: confOrBaseline [
	^ self command
		option: 'metacello';
		option: 'install';
		option: url asString;
		option: confOrBaseline asString;
		future
]

{ #category : #accessing }
TKTDeployed >> install: url configurationOrBaselineName: confOrBaseline groups: aCollectionOfGroup [
	^ self command
		option: 'metacello';
		option: 'install';
		option: url asString;
		option: confOrBaseline asString;
		option: ('--groups={1}' format: {(',' join: aCollectionOfGroup)});
		future
]

{ #category : #'evalas yet unclassified' }
TKTDeployed >> isDeploy [
	^ true
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
			(f basename beginsWith: (archetype version readStream upTo: $-))
				and: [ f basename endsWith: '.sources' ] ]
]

{ #category : #'evalas yet unclassified' }
TKTDeployed >> startImageNoQuit: aString [
	| output return input |
	output := UUID new asString asFileReference.
	input := '
	| ston | 
	ston := STONWriter on: (''{1}'' asFileReference ensureDelete; writeStream).
	[ ston nextPut: [{2}] value  ] on:Error do: [ :e |  ston nextPut: e messageText ].
	ston close. 
  '
		format:
			{output fullName.
			aString}.
	return := (self commandUi
		option: 'eval';
		arguments:
			{'--no-quit'.
			input}) createOSSubprocess run.
	return isComplete
		ifTrue: [ self error: 'Error stargin image ' ].
	output exists
		ifTrue: [ | object |
			object := (STONReader on: output readStream) next.
			object isError
				ifTrue: [ object signal ] ].
	output ensureDelete.
	^ return
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
