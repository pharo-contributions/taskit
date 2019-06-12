Class {
	#name : #TKTVMProvider,
	#superclass : #TKTResourceProvider,
	#category : #TaskItForkIt
}

{ #category : #download }
TKTVMProvider >> downloadUrlForVm: vmVersion forImage: imageVersion architecture: anInteger [
	| platformName |
	platformName := OSPlatform current isUnix
		ifTrue: [ 'linux' ]
		ifFalse: [ OSPlatform current isWindows
				ifTrue: [ 'win' ]
				ifFalse: [ 'mac' ] ].
	^ 'http://files.pharo.org/get-files/' , imageVersion asString
		, '/pharo'
		,
			(anInteger = 32
				ifTrue: [ '' ]
				ifFalse: [ anInteger ]) asString , '-' , platformName , '-'
		, vmVersion , '.zip'
]

{ #category : #download }
TKTVMProvider >> downloadVm: aString forImage: aString2 architecture: anInteger at: aFileReference [
	| imageUrl zipFile |
	imageUrl := (self
		downloadUrlForVm: aString
		forImage: aString2
		architecture: anInteger) asZnUrl.
	zipFile := aFileReference / 'zipfile'.
	ZnClient new
		url: imageUrl;
		downloadTo: zipFile.
	self assert: zipFile exists.
	(ZipArchive new readFrom: zipFile) extractAllTo: aFileReference / 'pharo-vm'.
	(TKTSystem chmod
		option: '-R';
		option: '+x';
		argument: aFileReference fullName;
		future) synchronizeTimeout: 5 seconds.
	zipFile ensureDelete
]

{ #category : #intalling }
TKTVMProvider >> install: aVmSelector forImage: anImageSelector architecture: anInteger at: aFileReference [
	self
		installAllSymlinksTo:
			(self
				resolve: aVmSelector
				forImage: anImageSelector
				architecture: anInteger)
		at: aFileReference
]

{ #category : #accessing }
TKTVMProvider >> resolve: aString forImage: anImageVersion architecture: anInteger [
	| cache |
	aString = #current
		ifTrue: [ ^ {Smalltalk vmDirectory asFileReference} ].
	cache := self
		vmPathFor: aString
		forImage: anImageVersion
		architecture: anInteger.
	(cache exists and: [ cache entries size = 1 ])
		ifFalse: [ cache ensureCreateDirectory.
			self
				downloadVm: aString
				forImage: anImageVersion
				architecture: anInteger
				at: cache.
			self assert: cache entries size = 1 ].
	^ cache entries
]

{ #category : #accessing }
TKTVMProvider >> vmPathFor: vmVersion forImage: imageVersion architecture: anInteger [
	^ 'pharo-local/forking/vm/' asFileReference / imageVersion
		/ (anInteger asString,'bits') / vmVersion
]
