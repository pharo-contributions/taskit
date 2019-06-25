"
The command declaration has as responsibility to spawn the proper objects , working as a generic interface easy to exchange. 
This version as well finds the address of the command if the given command is in the standard folders (for this go to #commandPath)
"
Class {
	#name : #TKTShellCommandDeclaration,
	#superclass : #Object,
	#instVars : [
		'command',
		'options',
		'arguments',
		'workingDirectory',
		'isVerbose'
	],
	#category : #TaskItShell
}

{ #category : #accessing }
TKTShellCommandDeclaration >> argument: anArgument [
	arguments add: anArgument.
	^ self
]

{ #category : #accessing }
TKTShellCommandDeclaration >> arguments: aSetOfArguments [
	arguments := aSetOfArguments asOrderedCollection.
	^ self
]

{ #category : #accessing }
TKTShellCommandDeclaration >> command: aCommandName [
	command := aCommandName
]

{ #category : #building }
TKTShellCommandDeclaration >> commandPath [
	command asFileReference exists
		ifTrue: [ ^ command ].
	^ ((':' split: (OSEnvironment current at: 'PATH')) collect: [ :p | p asFileReference / command  ] thenSelect: #exists) first fullName
]

{ #category : #accessing }
TKTShellCommandDeclaration >> consoleCommand [
	^ command , ' ' , (' ' join: options) , ' ' , (' ' join: arguments)
]

{ #category : #building }
TKTShellCommandDeclaration >> createOSSubprocess [
	^ OSSUnixSubprocess new
		workingDirectory: self workingDirectory;
		command: self commandPath;
		arguments: (options , arguments) asArray;
		yourself
]

{ #category : #convenience }
TKTShellCommandDeclaration >> fixedTask [
	^ TKTFixedCommandTask new
		command: self;
		yourself
]

{ #category : #convenience }
TKTShellCommandDeclaration >> future [
	^ self fixedTask future
]

{ #category : #convenience }
TKTShellCommandDeclaration >> future: aRunner [
	^ self fixedTask future: aRunner
]

{ #category : #accessing }
TKTShellCommandDeclaration >> initialize [
	super initialize.
	options := OrderedCollection new.
	arguments := OrderedCollection new
]

{ #category : #testing }
TKTShellCommandDeclaration >> isCommandDeclaration [
	^ true
]

{ #category : #executing }
TKTShellCommandDeclaration >> isVerbose [
	^ isVerbose ifNil: [ isVerbose := true ]
]

{ #category : #convenience }
TKTShellCommandDeclaration >> ls [
	self command: #ls.
	^ self
]

{ #category : #accessing }
TKTShellCommandDeclaration >> option: anOption [
	options add: anOption.
	^ self
]

{ #category : #accessing }
TKTShellCommandDeclaration >> option: anOption value: aValue [
	options add: anOption.
	options add: aValue.
	^ self
]

{ #category : #accessing }
TKTShellCommandDeclaration >> options: aSetOfOptions [
	options := aSetOfOptions asOrderedCollection.
	^ self
]

{ #category : #executing }
TKTShellCommandDeclaration >> redirectStdoutAsResult [
	isVerbose := false
]

{ #category : #executing }
TKTShellCommandDeclaration >> redirectStdoutToConsole [
	isVerbose := true
]

{ #category : #convenience }
TKTShellCommandDeclaration >> schedule [
	^ self fixedTask schedule
]

{ #category : #convenience }
TKTShellCommandDeclaration >> schedule: aRunner [
	^ self fixedTask schedule: aRunner
]

{ #category : #accessing }
TKTShellCommandDeclaration >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
TKTShellCommandDeclaration >> workingDirectory: aString [
	workingDirectory := aString
]
