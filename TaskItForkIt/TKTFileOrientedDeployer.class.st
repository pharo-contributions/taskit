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

{ #category : #'deploy destination' }
TKTFileOrientedDeployer >> backupCurrentImage [
	| session |
	session := Smalltalk session.
	Smalltalk image
		backupTo: (self currentCacheFolder / 'Pharo') fullName.
	session ~= Smalltalk session
		ifTrue: [ UIManager default spawnNewProcess.
			Processor activeProcess terminate ].
	^ {(self currentCacheFolder / 'Pharo.image').
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

{ #category : #'system calls' }
TKTFileOrientedDeployer >> copyAll: aCollection to: aFileReference [
	self assert: aFileReference isDirectory.
	aCollection do: [ :f | self copy: f to: aFileReference / f basename ]
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

{ #category : #'image calls' }
TKTFileOrientedDeployer >> downloadUrlForVm: vmVersion forImage: imageVersion architecture: anInteger [
	^ 'http://files.pharo.org/get-files/{1}/pharo{2}-{3}-{4}.zip'
		format:
			{imageVersion asString.
			(anInteger = 32
				ifTrue: [ '' ]
				ifFalse: [ anInteger ]) asString.
			self platformName.
			vmVersion}
]

{ #category : #'deploy destination' }
TKTFileOrientedDeployer >> downloadVm: vmVersion forImage: imageVersion architecture: anInteger at: aFileReference [
	| imageUrl zipFile |
	imageUrl := (self
		downloadUrlForVm: vmVersion
		forImage: imageVersion
		architecture: anInteger) asZnUrl.
	zipFile := aFileReference / 'zipfile'.
	ZnClient new
		url: imageUrl;
		downloadTo: zipFile.
	self assert: zipFile exists.
	TKTSystem unzip: zipFile into: aFileReference / 'pharo-vm'.
	"(ZipArchive new readFrom: zipFile) extractAllTo: aFileReference / 'pharo-vm'."
	(TKTSystem chmod
		option: '-R';
		option: '+x';
		argument: aFileReference fullName;
		future) synchronizeTimeout: 5 seconds.
	zipFile ensureDelete
]

{ #category : #'deploy destination' }
TKTFileOrientedDeployer >> ensureInstallationDirectoryFor: anArchetype [
	(self archetypesDestinationFor: anArchetype) exists
		ifTrue: [ self rm: (self archetypesDestinationFor: anArchetype) ].
	(self archetypesDestinationFor: anArchetype) ensureCreateDirectory
]

{ #category : #'deploy destination' }
TKTFileOrientedDeployer >> ensureToCleanupCurrentCache [
	(self currentCacheFolder / 'Pharo.image') ensureDelete.
	(self currentCacheFolder / 'Pharo.changes') ensureDelete.
	self currentCacheFolder ensureCreateDirectory
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
	self halt: 'check cache '.
	self copy: bundle to: location 
]

{ #category : #'system calls' }
TKTFileOrientedDeployer >> installSymlinkTo: aFileReference at: aDestination [
	^ backend installSymlinkTo: aFileReference at: aDestination
]

{ #category : #accessing }
TKTFileOrientedDeployer >> installVm: aVm at: location [
	self halt: 'check cache '.
	self installSymlinkTo: aVm at: location
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
	self ensureToCleanupCurrentCache.
	^ self backupCurrentImage
]

{ #category : #'deploy destination' }
TKTFileOrientedDeployer >> resolveCurrentVM [
	^ Smalltalk vmDirectory asFileReference
]

{ #category : #'deploy destination' }
TKTFileOrientedDeployer >> resolveVm: aVmSelector forImage: anImageSelector architecture: anInteger [
	| cache |
	cache := self
		vmPathFor: aVmSelector
		forImage: anImageSelector
		architecture: anInteger.
	(cache exists and: [ cache entries size = 1 ])
		ifFalse: [ cache ensureCreateDirectory.
			self
				downloadVm: aVmSelector
				forImage: anImageSelector
				architecture: anInteger
				at: cache.
			self assert: cache entries size = 1 ].
	^ cache / #'pharo-vm'
]

{ #category : #'system calls' }
TKTFileOrientedDeployer >> rm: aFileOrFolder [
	^ backend rm: aFileOrFolder
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

{ #category : #folder }
TKTFileOrientedDeployer >> vmPathFor: vmVersion forImage: imageVersion architecture: anInteger [
	^ self vmFolder / imageVersion / (anInteger asString , 'bits')
		/ vmVersion
]

{ #category : #working }
TKTFileOrientedDeployer >> workingDirectory [
	^ backend workingDirectory
]
