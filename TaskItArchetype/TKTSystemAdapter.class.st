"
The system backend it defines what it means the diferent system calls. This responsibility allows to plug different platforms backends as well as remote or local platforms
"
Class {
	#name : #TKTSystemAdapter,
	#superclass : #Object,
	#instVars : [
		'workingDirectory'
	],
	#classInstVars : [
		'local',
		'remote'
	],
	#category : #'TaskItArchetype-Deployer'
}

{ #category : #accessing }
TKTSystemAdapter class >> fromSymbol: aSymbol [
	^ self perform: aSymbol
]

{ #category : #accessing }
TKTSystemAdapter class >> local [
	^ local ifNil: [ local := self new  ]
]

{ #category : #accessing }
TKTSystemAdapter class >> remote [
	^ remote ifNil: [ remote := self new  ]
]

{ #category : #copying }
TKTSystemAdapter >> chmod: aFileReference flag: aString [
	(TKTSystem chmod
		option: aString;
		argument: aFileReference fullName;
		future) synchronizeTimeout: 1 minute.
]

{ #category : #folder }
TKTSystemAdapter >> command: aReference for: aDeployed [
	^ aReference command
		option: '--headless';
		option: aDeployed imageFile fullName;
		yourself
]

{ #category : #folder }
TKTSystemAdapter >> commandUi: aReference for: aDeployed [
	^ aReference command
		option: aDeployed imageFile fullName;
		yourself
]

{ #category : #copying }
TKTSystemAdapter >> copy: aFileReference to: aDestination [
	^ (TKTSystem cp
		option: '-r';
		arguments:
			{aFileReference asFileReference fullName.
			aDestination asFileReference fullName};
		future) synchronizeTimeout: 1 minute
]

{ #category : #folder }
TKTSystemAdapter >> copyAll: aCollection to: aFileReference [
	self assert: aFileReference isDirectory.
	^ aCollection
		collect: [ :f | self copy: f to: aFileReference / f basename ]
]

{ #category : #folder }
TKTSystemAdapter >> downloadAndUnzip: aZnUrl at: expectedLocation [
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
TKTSystemAdapter >> installAllSymlinksTo: aCollection at: aDestination [
	self assert: aDestination isDirectory.
	^ aCollection
		collect: [ :f | self installSymlinkTo: f at: aDestination ]
]

{ #category : #copying }
TKTSystemAdapter >> installSymlinkTo: aFileReference at: aDestination [
	| destination |
	aFileReference basename = aDestination basename
		ifTrue: [ self halt ].
	destination := aDestination / aFileReference basename.
	self
		assert: aFileReference exists
		description: 'Trying to link a non existing reference '.
	^ (TKTSystem ln
		option: '-s';
		arguments:
			{aFileReference fullName.
			destination fullName};
		future) synchronizeTimeout: 1 minute
]

{ #category : #copying }
TKTSystemAdapter >> rm: aFileOrFolder [
	^ (TKTSystem rm
		option: '-rf';
		argument: aFileOrFolder fullName) future
		synchronizeTimeout: 1 minute
]

{ #category : #folder }
TKTSystemAdapter >> workingDirectory [
	^ workingDirectory
		ifNil: [ workingDirectory := Smalltalk imageDirectory ]
]

{ #category : #folder }
TKTSystemAdapter >> workingDirectory: aDirectory [
	workingDirectory := aDirectory
]
