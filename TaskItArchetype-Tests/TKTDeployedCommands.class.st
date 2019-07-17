Class {
	#name : #TKTDeployedCommands,
	#superclass : #TestCase,
	#instVars : [
		'deployed',
		'systemAdapter'
	],
	#category : #'TaskItArchetype-Tests'
}

{ #category : #tests }
TKTDeployedCommands >> argumentsFor: aCommand [
	^ (TKTShellCommandDeclaration slotNamed: 'arguments') read: aCommand
]

{ #category : #tests }
TKTDeployedCommands >> commandFor: aCommand [
	^ (TKTShellCommandDeclaration slotNamed: 'command') read: aCommand
]

{ #category : #tests }
TKTDeployedCommands >> isTravisBuild [
	^ FileLocator changes resolve basename = 'TravisCI.changes'
]

{ #category : #tests }
TKTDeployedCommands >> optionsFor: aCommand [
	^ (TKTShellCommandDeclaration slotNamed: 'options') read: aCommand
]

{ #category : #running }
TKTDeployedCommands >> setUp [
	super setUp.
	
	systemAdapter := TKTDummyBackendStub new.
	deployed := TKTDeployed new
		initializeWithLocation: Smalltalk imageDirectory
		archetype: TKTArchetype thisImage
		andSystemAdapter: systemAdapter.
]

{ #category : #tests }
TKTDeployedCommands >> testChangesFiles [
	self isTravisBuild
		ifTrue: [ ^ self skip ].
	self assert: deployed changesFile equals: FileLocator changes resolve
]

{ #category : #tests }
TKTDeployedCommands >> testCommandPointsToPharoScript [
	| command |
	self isTravisBuild
		ifTrue: [ ^ self skip ].
	command := deployed command.
	self assert: command isCommandDeclaration.
	self assert: ((self commandFor: command) endsWith: 'pharo').
	self assert: systemAdapter commandCalled equals: 1.
	self assert: (self optionsFor: command) size equals: 1.
	self
		assert: ((self optionsFor: command) first endsWith: 'Pharo.image').
	self assert: (self argumentsFor: command) isEmpty
]

{ #category : #tests }
TKTDeployedCommands >> testCommandUiPointsToPharoUiScript [
	| command |
	self isTravisBuild
		ifTrue: [ ^ self skip ].
	command := deployed commandUi.
	self assert: command isCommandDeclaration.
	self assert: ((self commandFor: command) endsWith: 'pharo-ui').
	self assert: systemAdapter commandCalled equals: 1.
	self assert: (self optionsFor: command) size equals: 1.
	self
		assert: ((self optionsFor: command) first endsWith: 'Pharo.image').
	self assert: (self argumentsFor: command) isEmpty
]

{ #category : #tests }
TKTDeployedCommands >> testEvalCommandPointsToCommandAndHasOptions [
	| command |
	self isTravisBuild
		ifTrue: [ ^ self skip ].
	command := deployed eval.
	self assert: command isCommandDeclaration.
	self assert: ((self commandFor: command) endsWith: 'pharo').
	self assert: systemAdapter commandCalled equals: 1.
	self assert: (self optionsFor: command) size equals: 2.
	self
		assert: ((self optionsFor: command) first endsWith: 'Pharo.image').
	self assert: (self optionsFor: command) second equals: 'eval'.
	self assert: (self argumentsFor: command) isEmpty
]

{ #category : #tests }
TKTDeployedCommands >> testImageDirectory [
	self isTravisBuild
		ifTrue: [ ^ self skip ].
	self
		assert: deployed imageFile
		equals: Smalltalk imageDirectory / 'Pharo.image'
]

{ #category : #tests }
TKTDeployedCommands >> testSourceFiles [
	self isTravisBuild
		ifTrue: [ ^ self skip ].
	self assert: deployed sourcesFile equals: Smalltalk sourcesFile
]

{ #category : #tests }
TKTDeployedCommands >> testVmBinary [
	self isTravisBuild
		ifTrue: [ ^ self skip ].
	self
		assert: deployed vmBinary
		equals:
			(OSPlatform current isMacOS
				ifTrue: [ Smalltalk imageDirectory / 'pharo-vm' / 'Pharo.app' / #Contents
						/ #MacOS / #Pharo ]
				ifFalse: [ Smalltalk imageDirectory / 'pharo-vm' / #pharo ])
]

{ #category : #tests }
TKTDeployedCommands >> testVmDirectory [ 

	self assert: deployed vmFolder equals: Smalltalk imageDirectory / 'pharo-vm'
]
