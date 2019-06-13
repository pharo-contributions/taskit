Class {
	#name : #TKTResourceProvider,
	#superclass : #Object,
	#category : #TaskItForkIt
}

{ #category : #copying }
TKTResourceProvider >> copy: aFileReference to: aDestination [
	(TKTSystem cp
		option: '-r';
		arguments:
			{aFileReference asFileReference fullName.
			aDestination asFileReference fullName};
		future) synchronizeTimeout: 1 minute.
	"
	aFileReference isDirectory
		ifTrue: [ aFileReference asFileReference copyAllTo: aDestination ]
		ifFalse: [ aFileReference asFileReference copyTo: aDestination ]."
	^ aDestination
]

{ #category : #copy }
TKTResourceProvider >> copyAll: aCollection to: aFileReference [
	self assert: aFileReference isDirectory.
	aCollection do: [ :f | self copy: f to: aFileReference / f basename ]
]

{ #category : #'resolving and install' }
TKTResourceProvider >> install: aProject at: aDeployed [
	aProject deployIn: aDeployed
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
