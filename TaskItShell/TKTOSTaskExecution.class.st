"
This specific kind of task execution, relies on the task for knwoing what to execute, it executes depending on the installed library for communicating to the OS (osprocess, ossubprocess), and deploying the result on a future as value or error 
"
Class {
	#name : #TKTOSTaskExecution,
	#superclass : #TKTFutureExecution,
	#category : 'TaskItShell'
}

{ #category : #evaluating }
TKTOSTaskExecution >> doExecuteTask [
	[ future deploySuccess: self executeCommand ] 
		on: Error
		do: [ :error | future deployFailure: error ].
]

{ #category : #private }
TKTOSTaskExecution >> executeCommand [
	task command createOSSubprocess
		redirectStdout;
		redirectStderr;
		runAndWaitOnExitDo: [ :process :outString :errString | 
			process isSuccess
				ifTrue: [ ^ outString ]
				ifFalse: [ Error signal: errString ] ]
]
