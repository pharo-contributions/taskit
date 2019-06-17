Class {
	#name : #TKTArchetypedTaskExecution,
	#superclass : #TKTFutureExecution,
	#category : #'TaskItForkIt-Worker'
}

{ #category : #evaluating }
TKTArchetypedTaskExecution >> doExecuteTask [
	[ future deploySuccess: (runner sendTaskAndProcessResponse: task) ]
		on: Error
		do: [ :error | future deployFailure: error freeze ]
]