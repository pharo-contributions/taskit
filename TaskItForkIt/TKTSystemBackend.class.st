"
The system backend it defines what it means the diferent system calls. This responsibility allows to plug different platforms backends as well as remote or local platforms
"
Class {
	#name : #TKTSystemBackend,
	#superclass : #Object,
	#instVars : [
		'workingDirectory'
	],
	#classInstVars : [
		'local',
		'remote'
	],
	#category : #'TaskItForkIt-ImageBuilding'
}

{ #category : #accessing }
TKTSystemBackend class >> fromSymbol: aSymbol [
	^ self perform: aSymbol
]

{ #category : #accessing }
TKTSystemBackend class >> local [
	^ local ifNil: [ local := self new  ]
]

{ #category : #accessing }
TKTSystemBackend class >> remote [
	^ remote ifNil: [ remote := self new  ]
]

{ #category : #copying }
TKTSystemBackend >> chmod: aFileReference flag: aString [
	(TKTSystem chmod
		option: aString;
		argument: aFileReference fullName;
		future) synchronizeTimeout: 5 seconds
]

{ #category : #folder }
TKTSystemBackend >> command: aReference for: aDeployed [
	^ aReference command
		option: aDeployed imageFile fullName;
		yourself
]

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
TKTSystemBackend >> installAllSymlinksTo: aCollection at: aDestination [
	self assert: aDestination isDirectory.
	aCollection do: [ :f | self installSymlinkTo: f at: aDestination ]
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
