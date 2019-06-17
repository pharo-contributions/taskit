Class {
	#name : #TKTSourceProvider,
	#superclass : #TKTResourceProvider,
	#category : #'TaskItForkIt-ImageBuilding'
}

{ #category : #'resolving and install' }
TKTSourceProvider >> install: aString architecture: anArchitecture at: aFileReference [ 
	self installSymlinkTo: (self resolve: aString architecture: anArchitecture ) at: aFileReference.
	
]

{ #category : #resolving }
TKTSourceProvider >> resolve: aString architecture: anArchitecture [
	| previouslySolved |
	aString = #current
		ifTrue: [ ^ Smalltalk sourcesFile ].
	previouslySolved := self
		imagePathFor: aString
		architecture: anArchitecture.
	self assert: previouslySolved exists.
	^ previouslySolved entries detect: [ :e | e extension = #sources ]
]
