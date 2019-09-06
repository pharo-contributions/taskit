"
This specific kind of task, relies on the task for knwoing what to execute, it executes depending on the installed library for communicating to the OS (osprocess, ossubprocess), and deploying the result on a future as value or error 
"
Class {
	#name : #TKTShellCommandTask,
	#superclass : #TKTTask,
	#instVars : [
		'command'
	],
	#category : #TaskItShell
}

{ #category : #executing }
TKTShellCommandTask >> command [
	^ command ifNil: [ self error: 'Not command setted! ' ]
]

{ #category : #executing }
TKTShellCommandTask >> command: aCommand [ 
	^ command := aCommand
]

{ #category : #private }
TKTShellCommandTask >> evaluateOn: aTaskExecution [
	^ self command isVerbose
		ifTrue: [ self executeCommandStdoutConsole ]
		ifFalse: [ self executeCommandStdoutAsResult ]
]

{ #category : #private }
TKTShellCommandTask >> executeCommandStdoutAsResult [
	self command createOSSubprocess
		redirectStdout;
		redirectStderr;
		runAndWaitOnExitDo: [ :process :outString :errString | 
			process isSuccess
				ifTrue: [ ^ outString ]
				ifFalse: [ Error signal: errString ] ]
]

{ #category : #private }
TKTShellCommandTask >> executeCommandStdoutConsole [
	self command createOSSubprocess
		runAndWaitOnExitDo: [ :process :outString :errString | 
			process isSuccess
				ifTrue: [ ^ outString ]
				ifFalse: [ Error signal: errString ] ]
]
