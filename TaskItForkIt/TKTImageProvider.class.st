Class {
	#name : #TKTImageProvider,
	#superclass : #TKTResourceProvider,
	#category : #'TaskItForkIt-ImageBuilding'
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
TKTImageProvider >> imageUrlFor: aString and: anArchitecture [
	^ 'http://files.pharo.org/get-files/' , aString asString , '/pharo'
		,
			(anArchitecture = 32
				ifTrue: [ '' ]
				ifFalse: [ anArchitecture asString ]) , '.zip'
]
