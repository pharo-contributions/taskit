Class {
	#name : #TKTImageProvider,
	#superclass : #TKTResourceProvider,
	#category : #TaskItForkIt
}

{ #category : #resolving }
TKTImageProvider >> download: aString architecture: anArchitecture at: destination [
	| imageUrl zipFile |
	
	
	imageUrl := (self imageUrlFor: aString and: anArchitecture) asZnUrl.
	zipFile := destination / 'zipfile'.
	ZnClient new
		url: imageUrl;
		downloadTo: zipFile.
		
	self assert: zipFile exists.
	(ZipArchive new readFrom: zipFile) extractAllTo: destination.
	zipFile ensureDelete.
	destination children
		select: [ :c | #(image changes) includes: c extension ]
		thenDo: [ :child | child renameTo: 'Pharo.' , child extension ]
]

{ #category : #resolving }
TKTImageProvider >> imagePathFor: aString architecture: anArchitecture [
	^ 'pharo-local' asFileReference / #forking / #image
		/ anArchitecture asString
]

{ #category : #resolving }
TKTImageProvider >> imageUrlFor: aString and: anArchitecture [
	^ 'http://files.pharo.org/get-files/' , aString asString , '/pharo'
		,
			(anArchitecture = 32
				ifTrue: [ '' ]
				ifFalse: [ anArchitecture asString ]) , '.zip'
]

{ #category : #install }
TKTImageProvider >> install: aString architecture: anInteger at: aFileReference [ 
	self copyAll: (self resolve: aString architecture: anInteger) to: aFileReference

]

{ #category : #resolving }
TKTImageProvider >> resolve: aString architecture: anArchitecture [
	| cache |
	aString asString = 'current'
		ifTrue: [ ^ self resolveCurrentImageAsOption ].
	cache := self imagePathFor: aString architecture: anArchitecture.
	(cache exists and: [ cache entries isNotEmpty ])
		ifFalse: [ cache ensureCreateDirectory.
			self download: aString architecture: anArchitecture at: cache.
			self assert: cache entries size = 4 ].
	^ {(cache / #'Pharo.image').
	(cache / #'Pharo.changes')}
]

{ #category : #resolving }
TKTImageProvider >> resolveCurrentImageAsOption [
	| session |
	session := Smalltalk session.
	'pharo-local/forking/current/Pharo.image' asFileReference
		ensureDelete.
	'pharo-local/forking/current/Pharo.changes' asFileReference
		ensureDelete.
	'pharo-local/forking/current' asFileReference ensureCreateDirectory.
	Smalltalk image backupTo: 'pharo-local/forking/current/Pharo'.
	session ~= Smalltalk session
		ifTrue: [ UIManager default spawnNewProcess.
			Processor activeProcess terminate ].
	^ {'pharo-local/forking/current/Pharo.image' asFileReference.
	'pharo-local/forking/current/Pharo.changes' asFileReference}
]
