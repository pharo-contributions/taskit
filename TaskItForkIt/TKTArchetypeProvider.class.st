Class {
	#name : #TKTArchetypeProvider,
	#superclass : #TKTResourceProvider,
	#instVars : [
		'deployer'
	],
	#category : #TaskItForkIt
}

{ #category : #accessing }
TKTArchetypeProvider class >> default [
	^ self new
		deployer: TKTDeployer default;
		yourself
]

{ #category : #'resolving and install' }
TKTArchetypeProvider >> buildArchetype: anArchetype [
	anArchetype parent
		ifNil: [ self ensureInstallationDirectory: anArchetype.
			self deployer
				deploy: anArchetype
				at: self archetypesFolder / anArchetype name ]
		ifNotNil: [ self
				install: anArchetype parent
				at: self archetypesFolder / anArchetype name.
			self updateArchetype: anArchetype ].
	self installStonFile: anArchetype
]

{ #category : #'resolving and install' }
TKTArchetypeProvider >> clone: anArchetype at: aLocation [
	| date reader copy |
	reader := STONReader
		on:
			(self archetypesFolder / anArchetype name / anArchetype name , 'ston')
				readStream.
	date := reader next.
	copy := reader next.
	(self shouldReBuild: DateAndTime now - date)
		ifTrue: [ self buildArchetype: anArchetype ].
	(self shouldUpdate: DateAndTime now - date)
		ifTrue: [ self updateArchetype: anArchetype ].
	self copy: self archetypesFolder / anArchetype name to: aLocation.
	^ TKTDeployed new
		initializeWithLocation: aLocation
		andArchetype: anArchetype
]

{ #category : #'resolving and install' }
TKTArchetypeProvider >> deployer [
	^ deployer
]

{ #category : #'resolving and install' }
TKTArchetypeProvider >> deployer: aDeployer [
	deployer := aDeployer
]

{ #category : #accessing }
TKTArchetypeProvider >> ensureInstallationDirectory: anArchetype [
	(self archetypesFolder / anArchetype name) exists
		ifTrue: [ self rm: self archetypesFolder / anArchetype name ].
	(self archetypesFolder / anArchetype name) ensureCreateDirectory
]

{ #category : #'resolving and install' }
TKTArchetypeProvider >> install: anArchetype at: aLocation [
	(self archetypesFolder / anArchetype name / anArchetype name , 'ston')
		exists
		ifFalse: [ self buildArchetype: anArchetype ].
	self
		assert:
			(self archetypesFolder / anArchetype name / anArchetype name , 'ston')
				exists.
	^ self clone: anArchetype at: aLocation
]

{ #category : #'resolving and install' }
TKTArchetypeProvider >> installOnDefaultLocation: anArchetype [
	(self defaultDeployFolder / anArchetype name) ensureCreateDirectory.
	^ self
		install: anArchetype
		at: self defaultDeployFolder / anArchetype name / UUID new asString
]

{ #category : #'resolving and install' }
TKTArchetypeProvider >> installStonFile: anArchetype [
	(STONWriter
		on:
		(self archetypesFolder / anArchetype name / anArchetype name , 'ston')
		writeStream)
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
TKTArchetypeProvider >> updateArchetype: anArchetype [
	self deployer
		updateDeployed:
			(TKTDeployed new
				initializeWithLocation: self archetypesFolder / anArchetype name
					andArchetype: anArchetype;
				yourself)
]
