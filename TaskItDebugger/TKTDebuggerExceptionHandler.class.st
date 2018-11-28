"
I am an exception handler that opens a debugger on an unhandled task's failure.
"
Class {
	#name : #TKTDebuggerExceptionHandler,
	#superclass : #TKTExceptionHandler,
	#category : 'TaskItDebugger'
}

{ #category : #handling }
TKTDebuggerExceptionHandler >> handleException: anError [ 
	anError debug
]
