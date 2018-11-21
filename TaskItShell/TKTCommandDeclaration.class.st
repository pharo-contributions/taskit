"
The command declaration has as responsibility to spawn the proper objects , working as a generic interface easy to exchange. 
This version as well finds the address of the command if the given command is in the standard folders (for this go to #commandPath)
"
Class {
	#name : #TKTCommandDeclaration,
	#superclass : #Object,
	#instVars : [
		'command',
		'options',
		'arguments',
		'workingDirectory'
	],
	#category : 'TaskItShell'
}

{ #category : #accessing }
TKTCommandDeclaration >> argument: anArgument [
	arguments add: anArgument.
	^ self
]

{ #category : #accessing }
TKTCommandDeclaration >> arguments: aSetOfArguments [
	arguments := aSetOfArguments asOrderedCollection.
	^ self
]

{ #category : #accessing }
TKTCommandDeclaration >> command: aCommandName [
	command := aCommandName
]

{ #category : #building }
TKTCommandDeclaration >> commandPath [
	command asFileReference exists
		ifTrue: [ ^ command ].
	^ ((':' split: (OSEnvironment current at: 'PATH')) collect: [ :p | p asFileReference / command ] thenSelect: #exists) first fullName
]

{ #category : #building }
TKTCommandDeclaration >> createOSSubprocess [
	^ OSSUnixSubprocess new
		workingDirectory: self workingDirectory;
		command: self commandPath;
		arguments: (options , arguments) asArray;
		yourself
]

{ #category : #accessing }
TKTCommandDeclaration >> initialize [
	super initialize.
	options := OrderedCollection new.
	arguments := OrderedCollection new
]

{ #category : #testing }
TKTCommandDeclaration >> isCommandDeclaration [
	^ true
]

{ #category : #convenience }
TKTCommandDeclaration >> ls [
	self command: #ls.
	^ self
]

{ #category : #accessing }
TKTCommandDeclaration >> option: anOption [
	options add: anOption.
	^ self
]

{ #category : #accessing }
TKTCommandDeclaration >> options: aSetOfOptions [
	options := aSetOfOptions asOrderedCollection.
	^ self
]

{ #category : #accessing }
TKTCommandDeclaration >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
TKTCommandDeclaration >> workingDirectory: aString [
	workingDirectory := aString
]
