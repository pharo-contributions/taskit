"
The file oriented deployer is based on th fact that the resource provider will provide URLS and that the installation will be done by downloading already bootstrapped images as well as already compiled VMs.

Since is file based, it integrates as well a cache. that will be nice to extract to other object in the near future. 

This responsibility allows to redefine how to interpret the provided resources realted to an archetype. 
"
Class {
	#name : #TKTFileOrientedDeployer,
	#superclass : #Object,
	#instVars : [
		'provider',
		'systemAdapter'
	],
	#category : #'TaskItArchetype-Deployer'
}

{ #category : #accessing }
TKTFileOrientedDeployer class >> default [
	^ self new
		systemAdapter: TKTSystemAdapter new;
		yourself
]

{ #category : #accessing }
TKTFileOrientedDeployer class >> pharoScript [
	^ '
#!/usr/bin/env bash
# some magic to find out the real location of this script dealing with symlinks
DIR=`readlink "$0"` || DIR="$0";
DIR=`dirname "$DIR"`;
cd "$DIR"
DIR=`pwd`
cd - > /dev/null
# disable parameter expansion to forward all arguments unprocessed to the VM
set -f
# run the VM and pass along all arguments as is
"$DIR"/"pharo-vm/Pharo.app/Contents/MacOS/Pharo" --headless "$@"'
]

{ #category : #accessing }
TKTFileOrientedDeployer class >> pharoUiScript [
	^ '#!/usr/bin/env bash
# some magic to find out the real location of this script dealing with symlinks
DIR=`readlink "$0"` || DIR="$0";
DIR=`dirname "$DIR"`;
cd "$DIR"
DIR=`pwd`
cd - > /dev/null
# disable parameter expansion to forward all arguments unprocessed to the VM
set -f
# run the VM and pass along all arguments as is
"$DIR"/"pharo-vm/Pharo.app/Contents/MacOS/Pharo" "$@"'
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
	systemAdapter := aTKTSystemBackend
]

{ #category : #'deploy destination' }
TKTFileOrientedDeployer >> backupCurrentImage [
	| session sources |
	session := Smalltalk session.
	self currentCacheFolder ensureCreateDirectory.
	sources := Smalltalk imageDirectory entries
		select: [ :f | f basename endsWith: '.sources' ].
	sources isNotEmpty
		ifTrue: [ systemAdapter
				copy: sources first asFileReference
				to: self currentCacheFolder / sources first basename ].
	Smalltalk image
		backupTo: (self currentCacheFolder / 'Pharo') fullName.
	" in this place this image and the backup will be running it "
	session ~= Smalltalk session
		ifTrue: [ self cleanUpImageToStart ].
	^ {(self currentCacheFolder / sources first basename).
	(self currentCacheFolder / 'Pharo.image').
	(self currentCacheFolder / 'Pharo.changes')}
]

{ #category : #folder }
TKTFileOrientedDeployer >> baseFolder [
	^ systemAdapter workingDirectory / 'pharo-local' / #forking
]

{ #category : #'deploy destination' }
TKTFileOrientedDeployer >> cleanUpImageToStart [
	UIManager default spawnNewProcess.
	TKTConfiguration cleanUpImageToStart.
	^ Processor activeProcess terminate
]

{ #category : #'system calls' }
TKTFileOrientedDeployer >> copy: aFileReference to: aDestination [
	^ systemAdapter copy: aFileReference to: aDestination.

]

{ #category : #accessing }
TKTFileOrientedDeployer >> createScript: ref with: content [
	| stream |
	ref parent ensureCreateDirectory.
	ref ensureCreateFile.
	stream := ref writeStream.
	(ZnNewLineWriterStream on: stream)
		forPlatformLineEnding;
		nextPutAll: content;
		close.
	stream close.
	systemAdapter chmod: ref flag: '+x'
]

{ #category : #folder }
TKTFileOrientedDeployer >> currentCacheFolder [
	^ self baseFolder / #current
]

{ #category : #folder }
TKTFileOrientedDeployer >> defaultDeployFolder [
	^ self baseFolder / #deployCache
]

{ #category : #accessing }
TKTFileOrientedDeployer >> deploy: anArchetype at: location [
	| deployed |
	anArchetype parent
		ifNil: [ self deployFiles: anArchetype at: location ]
		ifNotNil: [ self deploy: anArchetype parent at: location ].
	self createScript: location / 'pharo' with: self class pharoScript.
	self
		createScript: location / 'pharo-ui'
		with: self class pharoUiScript.
	deployed := TKTDeployed new
		initializeWithLocation: location
			archetype: anArchetype
			andSystemAdapter: systemAdapter;
		yourself.
	self updateDeployed: deployed using: self.
	^ deployed
]

{ #category : #folder }
TKTFileOrientedDeployer >> deployAtDefaultLocation: anArchetype [
	| id |
	id := UUID new asString.
	^ self
		deploy: anArchetype
		at:
			((self defaultDeployFolder / anArchetype name / id)
				ensureCreateDirectory;
				yourself)
]

{ #category : #accessing }
TKTFileOrientedDeployer >> deployFiles: anArchetype at: location [
	| collection |
	collection := Set new.
	self ensureInstallationDirectoryFor: anArchetype.
	collection
		add:
			(self
				installVm:
					(provider
						resolveVM: anArchetype vmSelector
						forImage: anArchetype imageSelector
						architecture: anArchetype architectureSelector
						using: self)
				at: location).
	collection
		addAll:
			(self
				installImageAndSource:
					(provider
						resolvePharoBundle: anArchetype vmSelector
						forImage: anArchetype imageSelector
						architecture: anArchetype architectureSelector
						using: self)
				at: location).
	^ collection
]

{ #category : #folder }
TKTFileOrientedDeployer >> ensureInstallationDirectoryFor: anArchetype [
	(self archetypesDestinationFor: anArchetype) exists
		ifTrue: [ systemAdapter rm: (self archetypesDestinationFor: anArchetype) ].
	(self archetypesDestinationFor: anArchetype) ensureCreateDirectory
]

{ #category : #getting }
TKTFileOrientedDeployer >> fetchBundle: aZnUrl [
	| expectedLocation |
	expectedLocation := aZnUrl segments allButFirst
		inject: self imageFolder
		into: [ :acc :each | acc / (each copyReplaceAll: '.zip' with: '') ].
	expectedLocation exists
		ifFalse:
			[ self privateDownloadBundle: aZnUrl at: expectedLocation ].
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
			systemAdapter downloadAndUnzip: aZnUrl at: expectedLocation ].
	systemAdapter chmod: expectedLocation flag: '+x'.
	^ expectedLocation
]

{ #category : #folder }
TKTFileOrientedDeployer >> imageFolder [
	^ self baseFolder / #image
]

{ #category : #getting }
TKTFileOrientedDeployer >> initialize [
	super initialize.
	provider := TKTResourceProvider new
]

{ #category : #accessing }
TKTFileOrientedDeployer >> installImageAndSource: bundle at: location [
	| imageChangesAndSourceFileReferenceArray |
	imageChangesAndSourceFileReferenceArray := bundle = #current
		ifTrue: [ self resolveCurrentImageAnChangesFile ]
		ifFalse: [ self fetchBundle: bundle ].
	^ systemAdapter
		copyAll: imageChangesAndSourceFileReferenceArray
		to: location
]

{ #category : #accessing }
TKTFileOrientedDeployer >> installVm: aVm at: location [
	| vmFolderReference |
	vmFolderReference := aVm = #current
		ifTrue: [ self resolveCurrentVM ]
		ifFalse: [ self fetchVm: aVm ].
	^ systemAdapter installSymlinkTo: vmFolderReference at: location
]

{ #category : #accessing }
TKTFileOrientedDeployer >> platformName [
	^ OSPlatform current isUnix
		ifTrue: [ 'linux' ]
		ifFalse: [ OSPlatform current isWindows
				ifTrue: [ 'win' ]
				ifFalse: [ 'mac' ] ]
]

{ #category : #getting }
TKTFileOrientedDeployer >> privateDownloadBundle: aZnUrl at: expectedLocation [
	expectedLocation exists
		ifTrue: [ systemAdapter rm: expectedLocation ].
	expectedLocation ensureCreateDirectory.
	systemAdapter downloadAndUnzip: aZnUrl at: expectedLocation.
	
]

{ #category : #'image calls' }
TKTFileOrientedDeployer >> resolveCurrentImageAnChangesFile [
	(systemAdapter rm: self currentCacheFolder).
	self currentCacheFolder ensureCreateDirectory.
	^ self backupCurrentImage
]

{ #category : #'deploy destination' }
TKTFileOrientedDeployer >> resolveCurrentVM [
	^ Smalltalk vmDirectory asFileReference
]

{ #category : #accessing }
TKTFileOrientedDeployer >> systemAdapter: aTKTSystemSystemAdapter [
	systemAdapter := aTKTSystemSystemAdapter
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
	^ systemAdapter workingDirectory
]
