"
TKTOSTask is configured with a block that defines a command by sending messages to a TKTCommandDeclaration object., received by parameter.

This object has the responsibilty of building up the needed objects for running, depending on the currently installed OS interface library. 
This object as well responds to the following responsibilities:

    create an specific kind of task execution. 
"
Class {
	#name : #TKTOSTask,
	#superclass : #TKTTask,
	#instVars : [
		'block'
	],
	#category : 'TaskItShell'
}

{ #category : #'as yet unclassified' }
TKTOSTask class >> buildingCommandWith: aValuable [
	^ self new
		block: aValuable;
		yourself
]

{ #category : #accessing }
TKTOSTask >> block: aBuildingBlock [
	block := aBuildingBlock
]

{ #category : #accessing }
TKTOSTask >> command [
	| command |
	command := block value: TKTShellCommandDeclaration new.
	command isCommandDeclaration
		ifFalse: [ Error
				signal: 'The result of the OSTask block must be a command declaration' ].
	^ command
]

{ #category : #executing }
TKTOSTask >> futureTaskExecutionFor: aRunner [
	| execution |
	execution := TKTOSTaskExecution new.
	execution runner: aRunner.
	execution task: self.
	^ execution
]
