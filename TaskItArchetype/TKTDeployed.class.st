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
		'version',
		'systemAdapter'
	],
	#category : #'TaskItArchetype-Archetype'
}

{ #category : #accessing }
TKTDeployed >> archetype [
	^ archetype
]

{ #category : #accessing }
TKTDeployed >> changesFile [
	^ location / (#'Pharo{1}.changes' format: {self version})
]

{ #category : #accessing }
TKTDeployed >> clone [
	| newLocation |
	newLocation := location parent / UUID new asString.
	^ self cloneAt: newLocation
]

{ #category : #accessing }
TKTDeployed >> cloneAt: aLocation [ 
	^ self cloneAt: aLocation using: systemAdapter
]

{ #category : #accessing }
TKTDeployed >> cloneAt: aLocation using: aSystemAdapter [
	| clone |
	clone := TKTDeployed new.
	clone
		initializeWithLocation: aLocation
		archetype: archetype
		andSystemAdapter: aSystemAdapter.
	aSystemAdapter copy: location to: aLocation.
	^ clone
]

{ #category : #accessing }
TKTDeployed >> command [
	^ systemAdapter command: self vmBinary for: self
]

{ #category : #accessing }
TKTDeployed >> commandUi [
	^ systemAdapter commandUi: self vmBinary for: self
]

{ #category : #'evalas yet unclassified' }
TKTDeployed >> configureBackend: aBackend [
	aBackend deploy: self.
	aBackend archetype: archetype
]

{ #category : #accessing }
TKTDeployed >> crashDump [
	^ location / 'crash.dmp'
]

{ #category : #accessing }
TKTDeployed >> debugLog [ 
	^ location / 'PharoDebug.log'
]

{ #category : #'evalas yet unclassified' }
TKTDeployed >> delete [
	location exists
		ifTrue: [ systemAdapter rm: location ]
]

{ #category : #'evalas yet unclassified' }
TKTDeployed >> ensureIcebergRemoteTypeSelector: aSelector [
	^ self
		modifyImageBy: ('Iceberg remoteTypeSelector: ''{1}'' asSymbol' format: {aSelector})
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

{ #category : #testing }
TKTDeployed >> exists [
	^ location exists
]

{ #category : #accessing }
TKTDeployed >> imageFile [
	^ location / (#'Pharo{1}.image' format: {self version})
]

{ #category : #accessing }
TKTDeployed >> initializeWithLocation: aLocation archetype: anArquetype andSystemAdapter: aBackend [
	location := aLocation.
	archetype := anArquetype.
	systemAdapter := aBackend
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

{ #category : #'evalas yet unclassified' }
TKTDeployed >> modifyImageBy: aString [
	| future output input |
	output := UUID new asString asFileReference.
	input := '
	| stream | 
	[ [{2}] value  ] on:Error do: [ :e | 
		stream := ''{1}'' asFileReference ensureDelete; writeStream.
	 	stream nextPutAll: e messageText.
		stream close. ]. 
  '
		format:
			{output fullName.
			aString}.
	future := (self command
		option: 'eval';
		arguments:
			{'--save'.
			input}) future.
	^ future
		collect: [ :v | 
			output exists
				ifTrue: [ | message |
					message := output readStream upToEnd.
					output ensureDelete.
					self error: message ]
				ifFalse: [ v ] ]
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
	^ (location entries
		detect: [ :f | 
			(f basename beginsWith: (archetype version readStream upTo: $-))
				and: [ f basename endsWith: '.sources' ] ]
		ifNone: [ location entries detect: [ :f | f basename endsWith: '.sources' ] ])
		asFileReference
]

{ #category : #'evalas yet unclassified' }
TKTDeployed >> startImageNoQuit: aString [
	| return |
	return := (self command
		option: 'eval';
		arguments:
			{'--no-quit'.
			aString}) createOSSubprocess run.
	^ return
]

{ #category : #accessing }
TKTDeployed >> version [
	^ version
		ifNil: [ | image changes |
			image := (location entries
				detect:
					[ :e | (e basename beginsWith: 'Pharo') and: [ e basename endsWith: 'image' ] ])
				basename.
			changes := (location entries
				detect: [ :e | 
					(e basename beginsWith: 'Pharo')
						and: [ e basename endsWith: 'changes' ] ]) basename.
			version := image
				copyFrom: 'Pharo' size + 1
				to: image size - '.image' size.
			self
				assert:
					version
						=
							(changes copyFrom: 'Pharo' size + 1 to: changes size - '.changes' size).
			version ]
]

{ #category : #'evalas yet unclassified' }
TKTDeployed >> version: aVersion [
	version := aVersion 
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
	ref isFile
		ifFalse: [ ^ self error: 'Archetype #vmBinary does not exists' ].
	^ ref
]

{ #category : #'accessingas yet unclassified' }
TKTDeployed >> vmFolder [
	^ location / #'pharo-vm' 
]
