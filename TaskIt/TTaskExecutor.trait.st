"
I am a trait implementing the main behavior of a task executor. That is, an object that knows how to execute a task and handle its unhandled exceptions using an exception handler
"
Trait {
	#name : #TTaskExecutor,
	#category : 'TaskIt-Kernel'
}

{ #category : #accessing }
TTaskExecutor >> exceptionHandler [

	self requirement
]

{ #category : #executing }
TTaskExecutor >> executeTask: aTaskExecution [
	[ self noteBusy.
	aTaskExecution value.
	self noteFree ]
		on: Error
		do: [ :error | self exceptionHandler handleException: error ]
]

{ #category : #'as yet unclassified' }
TTaskExecutor >> noteBusy [

	self requirement
]

{ #category : #'as yet unclassified' }
TTaskExecutor >> noteFree [

	self requirement
]
