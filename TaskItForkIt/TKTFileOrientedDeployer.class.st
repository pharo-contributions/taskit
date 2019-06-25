Class {
	#name : #TKTFileOrientedDeployer,
	#superclass : #Object,
	#instVars : [
		'backend',
		'provider'
	],
	#category : #'TaskItForkIt-ImageBuilding'
}

{ #category : #accessing }
TKTFileOrientedDeployer class >> default [
	^ self new
		provider: TKTResourceProvider new;
		backend: TKTSystemBackend new;
		yourself
]

{ #category : #folder }
TKTFileOrientedDeployer >> archetypesDestination [
	^ self baseFolder / #archetypes
]

{ #category : #folder }
TKTFileOrientedDeployer >> archetypesDestinationFor: anArchetype [
	^ self archetypesDestination / anArchetype name
]

{ #category : #folder }
TKTFileOrientedDeployer >> archetypesStonDestinationFor: anArchetype [
	^ (self archetypesDestinationFor: anArchetype) / anArchetype name
		, 'ston'
]

{ #category : #accessing }
TKTFileOrientedDeployer >> backend: aTKTSystemBackend [ 
	backend := aTKTSystemBackend
]

{ #category : #'deploy destination' }
TKTFileOrientedDeployer >> backupCurrentImage [
	| session sources |
	session := Smalltalk session.
	Smalltalk image
		backupTo: (self currentCacheFolder / 'Pharo') fullName.
	sources := (Smalltalk imageDirectory entries
		detect: [ :f | f basename endsWith: '.sources' ]) asFileReference.
	sources copyTo: self currentCacheFolder / sources basename.
	session ~= Smalltalk session
		ifTrue: [ UIManager default spawnNewProcess.
			Processor activeProcess terminate ].
	^ {(self currentCacheFolder / sources basename).
	(self currentCacheFolder / 'Pharo.image').
	(self currentCacheFolder / 'Pharo.changes')}
]

{ #category : #folder }
TKTFileOrientedDeployer >> baseFolder [
	^ backend workingDirectory / 'pharo-local' / #forking
]

{ #category : #'system calls' }
TKTFileOrientedDeployer >> copy: aFileReference to: aDestination [
	^ backend copy: aFileReference to: aDestination.

]

{ #category : #'deploy destination' }
TKTFileOrientedDeployer >> currentCacheFolder [
	^ self baseFolder / #current
]

{ #category : #folder }
TKTFileOrientedDeployer >> defaultDeployArchetypeLocationFor: anArchetype [
	(self defaultDeployFolder / anArchetype name) ensureCreateDirectory.
	^ self defaultDeployFolder / anArchetype name / UUID new asString
]

{ #category : #folder }
TKTFileOrientedDeployer >> defaultDeployFolder [
	^ self baseFolder / #deployCache
]

{ #category : #accessing }
TKTFileOrientedDeployer >> deploy: anArchetype at: location [
	| deployed |
	self ensureInstallationDirectoryFor: anArchetype.
	self
		installVm:
			(provider
				resolveVM: anArchetype vmSelector
				forImage: anArchetype imageSelector
				architecture: anArchetype architectureSelector
				using: self)
		at: location.
	self
		installImageAndSource:
			(provider
				resolvePharoBundle: anArchetype vmSelector
				forImage: anArchetype imageSelector
				architecture: anArchetype architectureSelector
				using: self)
		at: location.
	deployed := TKTDeployed new
		initializeWithLocation: location andArchetype: anArchetype;
		yourself.
	self updateDeployed: deployed using: self.
	^ deployed
]

{ #category : #'deploy destination' }
TKTFileOrientedDeployer >> ensureInstallationDirectoryFor: anArchetype [
	(self archetypesDestinationFor: anArchetype) exists
		ifTrue: [ backend rm: (self archetypesDestinationFor: anArchetype) ].
	(self archetypesDestinationFor: anArchetype) ensureCreateDirectory
]

{ #category : #getting }
TKTFileOrientedDeployer >> fetchBundle: aZnUrl [
	| expectedLocation |
	expectedLocation := (aZnUrl segments allButFirst
		inject: self imageFolder 
		into: [ :acc :each | acc / (each copyReplaceAll: '.zip' with: '') ]).
	expectedLocation exists ifFalse: [ 
			expectedLocation ensureCreateDirectory.
			backend downloadAndUnzip: aZnUrl at: expectedLocation 
		].
	expectedLocation children
		select: [ :c | #(image changes) includes: c extension ]
		thenDo: [ :child | child renameTo: 'Pharo.' , child extension ].
		
	^ expectedLocation entries
]

{ #category : #fetch }
TKTFileOrientedDeployer >> fetchVm: aZnUrl [
	| expectedLocation |
	expectedLocation := (aZnUrl segments allButFirst
		inject: self vmFolder
		into: [ :acc :each | acc / (each copyReplaceAll: '.zip' with: '') ])
		/ 'pharo-vm'.
	expectedLocation exists
		ifFalse: [ expectedLocation ensureCreateDirectory.
			backend downloadAndUnzip: aZnUrl at: expectedLocation ].
	^ expectedLocation
]

{ #category : #folder }
TKTFileOrientedDeployer >> imageFolder [
	^ self baseFolder / #image
]

{ #category : #folder }
TKTFileOrientedDeployer >> imagePathFor: aString architecture: anArchitecture [
	^ self imageFolder / aString / anArchitecture asString
]

{ #category : #'system calls' }
TKTFileOrientedDeployer >> installAllSymlinksTo: aCollection at: aDestination [
	self assert: aDestination isDirectory.
	aCollection do: [ :f | self installSymlinkTo: f at: aDestination ]
]

{ #category : #accessing }
TKTFileOrientedDeployer >> installImageAndSource: bundle at: location [
	| imageChangesAndSourceFileReferenceArray |
	imageChangesAndSourceFileReferenceArray := bundle = #current
		ifTrue: [ self resolveCurrentImageAnChangesFile ]
		ifFalse: [ self fetchBundle: bundle ].
	backend copyAll: imageChangesAndSourceFileReferenceArray to: location
]

{ #category : #'system calls' }
TKTFileOrientedDeployer >> installSymlinkTo: aFileReference at: aDestination [
	^ backend installSymlinkTo: aFileReference at: aDestination
]

{ #category : #accessing }
TKTFileOrientedDeployer >> installVm: aVm at: location [
	| vmFolderReference |
	vmFolderReference := aVm = #current
		ifTrue: [ self resolveCurrentVM ]
		ifFalse: [ self fetchVm: aVm ].
	self installSymlinkTo: vmFolderReference at: location
]

{ #category : #accessing }
TKTFileOrientedDeployer >> platformName [
	^ OSPlatform current isUnix
		ifTrue: [ 'linux' ]
		ifFalse: [ OSPlatform current isWindows
				ifTrue: [ 'win' ]
				ifFalse: [ 'mac' ] ]
]

{ #category : #accessing }
TKTFileOrientedDeployer >> provider [
	^ provider
]

{ #category : #accessing }
TKTFileOrientedDeployer >> provider: aResourceProvider [
	provider := aResourceProvider
]

{ #category : #'image calls' }
TKTFileOrientedDeployer >> resolveCurrentImageAnChangesFile [
	(self currentCacheFolder / 'Pharo.image') ensureDelete.
	(self currentCacheFolder / 'Pharo.changes') ensureDelete.
	self currentCacheFolder ensureCreateDirectory.
	^ self backupCurrentImage
]

{ #category : #'deploy destination' }
TKTFileOrientedDeployer >> resolveCurrentVM [
	^ Smalltalk vmDirectory asFileReference
]

{ #category : #'image calls' }
TKTFileOrientedDeployer >> updateDeployed: aDeployed using: aDeployer [
	aDeployed archetype dependancies
		do: [ :d | provider installProject: d at: aDeployed using: aDeployer ]
]

{ #category : #folder }
TKTFileOrientedDeployer >> vmFolder [
	^ self baseFolder / #vm
]

{ #category : #working }
TKTFileOrientedDeployer >> workingDirectory [
	^ backend workingDirectory
]
