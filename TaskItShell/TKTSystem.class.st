"
System facade for unix systems.
"
Class {
	#name : #TKTSystem,
	#superclass : #Object,
	#category : #TaskItShell
}

{ #category : #'as yet unclassified' }
TKTSystem class >> bash: aScript [
	^ #bash command
		option: '-c';
		argument: aScript;
		redirectStdoutAsResult;
		yourself
]

{ #category : #'as yet unclassified' }
TKTSystem class >> chmod [
	^ #chmod command
		redirectStdoutAsResult;
		yourself
]

{ #category : #'as yet unclassified' }
TKTSystem class >> cp [
	^ #cp command
		redirectStdoutAsResult;
		yourself
]

{ #category : #'as yet unclassified' }
TKTSystem class >> grep [
	^ #grep command
		redirectStdoutAsResult;
		yourself
]

{ #category : #'as yet unclassified' }
TKTSystem class >> ln [
	^ #ln command
		redirectStdoutAsResult;
		yourself
]

{ #category : #'as yet unclassified' }
TKTSystem class >> ls [
	^ #ls command
		redirectStdoutAsResult;
		yourself
]

{ #category : #'as yet unclassified' }
TKTSystem class >> mv [
	^ #mv command
		redirectStdoutAsResult;
		yourself
]

{ #category : #'as yet unclassified' }
TKTSystem class >> rm [
	^ #rm command
		redirectStdoutAsResult;
		yourself
]

{ #category : #'as yet unclassified' }
TKTSystem class >> unzip [
	^ #unzip command
]

{ #category : #'as yet unclassified' }
TKTSystem class >> unzip: aFileReference into: aDirectory [
	aDirectory ensureCreateDirectory.
	^ (self unzip
		option: '-d' value: aDirectory fullName;
		argument: aFileReference fullName) future
		synchronizeTimeout: 5 minutes
]

{ #category : #'as yet unclassified' }
TKTSystem class >> wget: anUrl [
	^ #wget command
		arguments: {anUrl printString};
		yourself
]

{ #category : #'as yet unclassified' }
TKTSystem class >> wget: anUrl to: aDestination [
	| destination |
	destination := aDestination isDirectory
		ifTrue: [ aDestination / anUrl pathSegments last ]
		ifFalse: [ aDestination ].
	destination exists
		ifTrue: [ ^ self
				error: 'The chosen destination exists! Please, ensure a unique name' ].
	^ (self wget: anUrl)
		option: '-O' value: destination fullName;
		yourself
]
