"
I create a task who will not redirect stdout/stderr to a stream, which means all the output will be directed to console.
"
Class {
	#name : #TKTOSVerboseTask,
	#superclass : #TKTOSTask,
	#category : 'TaskItShell'
}

{ #category : #private }
TKTOSVerboseTask >> executionClass [
	^ TKTOSTaskVerboseExecution
]
