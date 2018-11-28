"
I'm a command to execute verbose tasks (verbose tasks do not redirect stdout/stderr so they write to console, if available).
"
Class {
	#name : #TKTOSTaskVerboseExecution,
	#superclass : #TKTOSTaskExecution,
	#category : 'TaskItShell'
}

{ #category : #private }
TKTOSTaskVerboseExecution >> executeCommand [
	task command createOSSubprocess
		runAndWaitOnExitDo: [ :process :outString :errString | 
			process isSuccess
				ifTrue: [ ^ outString ]
				ifFalse: [ Error signal: errString ] ]
]
