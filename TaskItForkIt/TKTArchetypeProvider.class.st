Class {
	#name : #TKTArchetypeProvider,
	#superclass : #TKTResourceProvider,
	#category : #'TaskItForkIt-ImageBuilding'
}

{ #category : #'resolving and install' }
TKTArchetypeProvider >> buildArchetype: anArchetype using: aDeployer [
	anArchetype parent
		ifNil: [ .
			aDeployer
				deploy: anArchetype
				at: (aDeployer archetypesDestinationFor: anArchetype) ]
		ifNotNil: [ 
			self
				install: anArchetype parent
				at: (aDeployer archetypesDestinationFor: anArchetype)
				using: aDeployer.
			self updateArchetype: anArchetype using: aDeployer ].
	self installStonFile: anArchetype using: aDeployer
]

{ #category : #'resolving and install' }
TKTArchetypeProvider >> clone: anArchetype at: aLocation using: aDeployer [
	| date reader copy |
	reader := STONReader
		on: (aDeployer archetypesStonDestinationFor: anArchetype) readStream.
	date := reader next.
	copy := reader next.
	(self shouldReBuild: DateAndTime now - date)
		ifTrue: [ self buildArchetype: anArchetype using: aDeployer ].
	(self shouldUpdate: DateAndTime now - date)
		ifTrue: [ self updateArchetype: anArchetype using: aDeployer ].
	aDeployer
		copy: (aDeployer archetypesDestinationFor: anArchetype)
		to: aLocation.
	^ TKTDeployed new
		initializeWithLocation: aLocation
		andArchetype: anArchetype
]

{ #category : #'resolving and install' }
TKTArchetypeProvider >> install: anArchetype at: aLocation using: aDeployer [
	(aDeployer archetypesStonDestinationFor: anArchetype) exists
		ifFalse: [ self buildArchetype: anArchetype using: aDeployer ].
	self
		assert: (aDeployer archetypesStonDestinationFor: anArchetype) exists.
	^ self clone: anArchetype at: aLocation using: aDeployer
]

{ #category : #'resolving and install' }
TKTArchetypeProvider >> installOnDefaultLocation: anArchetype using: aDeployer [
	^ self
		install: anArchetype
		at: (aDeployer defaultDeployArchetypeLocationFor: anArchetype)
		using: aDeployer
]

{ #category : #'resolving and install' }
TKTArchetypeProvider >> installStonFile: anArchetype using: aDeployer [
	(STONWriter
		on: (aDeployer archetypesStonDestinationFor: anArchetype) writeStream)
		nextPut: DateAndTime now;
		nextPut: anArchetype;
		close
]

{ #category : #'resolving and install' }
TKTArchetypeProvider >> shouldReBuild: aDuration [
	^ aDuration > 1 week
]

{ #category : #'resolving and install' }
TKTArchetypeProvider >> shouldUpdate: aDuration [
	^ aDuration > 30 minutes
]

{ #category : #'resolving and install' }
TKTArchetypeProvider >> updateArchetype: anArchetype using: aDeployer [
	aDeployer
		updateDeployed:
			(TKTDeployed new
				initializeWithLocation: (aDeployer archetypesDestinationFor: anArchetype)
					andArchetype: anArchetype;
				yourself)
		using: aDeployer
]
