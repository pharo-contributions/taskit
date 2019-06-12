Class {
	#name : #TKTResourceProvider,
	#superclass : #Object,
	#category : #TaskItForkIt
}

{ #category : #copying }
TKTResourceProvider >> copy: aFileReference to: aDestination [
	aFileReference isDirectory
		ifTrue: [ aFileReference copyAllTo: aDestination ]
		ifFalse: [ aFileReference copyTo: aDestination ].
	^ aDestination
]

{ #category : #copy }
TKTResourceProvider >> copyAll: aCollection to: aFileReference [
	self assert: aFileReference isDirectory.
	aCollection do: [ :f | self copy: f to: aFileReference / f basename ]
]

{ #category : #'resolving and install' }
TKTResourceProvider >> install: aString at: aFileReference [ 
	self subclassResponsibility 
]

{ #category : #linking }
TKTResourceProvider >> installAllSymlinksTo: aCollection at: aDestination [
	self assert: aDestination isDirectory.
	aCollection do: [ :f | self installSymlinkTo: f at: aDestination ]
]

{ #category : #linking }
TKTResourceProvider >> installSymlinkTo: aFileReference at: aDestination [
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
