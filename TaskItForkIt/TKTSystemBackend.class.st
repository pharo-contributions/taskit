Class {
	#name : #TKTSystemBackend,
	#superclass : #Object,
	#instVars : [
		'workingDirectory'
	],
	#category : #'TaskItForkIt-ImageBuilding'
}

{ #category : #copying }
TKTSystemBackend >> copy: aFileReference to: aDestination [
	(TKTSystem cp
		option: '-r';
		arguments:
			{aFileReference asFileReference fullName.
			aDestination asFileReference fullName};
		future) synchronizeTimeout: 1 minute.
	^ aDestination
]

{ #category : #folder }
TKTSystemBackend >> copyAll: aCollection to: aFileReference [
	self assert: aFileReference isDirectory.
	aCollection do: [ :f | self copy: f to: aFileReference / f basename ]
]

{ #category : #folder }
TKTSystemBackend >> downloadAndUnzip: aZnUrl at: expectedLocation [
	| zipFile |
	zipFile := expectedLocation / 'zipfile'.
	ZnClient new
		url: aZnUrl;
		downloadTo: zipFile.
	self assert: zipFile exists.
	TKTSystem unzip: zipFile into: expectedLocation.
	zipFile ensureDelete
]

{ #category : #copying }
TKTSystemBackend >> installSymlinkTo: aFileReference at: aDestination [
	| destination |
	destination := aDestination isDirectory
		ifTrue: [ aDestination / aFileReference basename ].
	^ (TKTSystem ln
		option: '-s';
		arguments:
			{aFileReference fullName.
			destination fullName};
		future) synchronizeTimeout: 2 seconds
]

{ #category : #copying }
TKTSystemBackend >> rm: aFileOrFolder [
	^ (TKTSystem rm
		option: '-rf';
		argument: aFileOrFolder fullName) future
		synchronizeTimeout: 1 minute
]

{ #category : #folder }
TKTSystemBackend >> workingDirectory [
	^ workingDirectory
		ifNil: [ workingDirectory := FileLocator workingDirectory ]
]

{ #category : #folder }
TKTSystemBackend >> workingDirectory: aDirectory [
	workingDirectory := aDirectory
]
