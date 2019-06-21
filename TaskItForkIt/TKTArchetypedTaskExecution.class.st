"
The archetyped task execution relies on the runner as dispatcher to the proper backend to the remote process
"
Class {
	#name : #TKTArchetypedTaskExecution,
	#superclass : #TKTFutureExecution,
	#category : #'TaskItForkIt-Task'
}

{ #category : #evaluating }
TKTArchetypedTaskExecution >> doExecuteTask [
	[ future deploySuccess: (runner doRemoteExecute: task) ]
		on: Error
		do: [ :error | future deployFailure: error freeze ]
]
