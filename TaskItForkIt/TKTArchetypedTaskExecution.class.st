"
The archetyped task execution relies on the runner as dispatcher to the proper backend to the remote process
"
Class {
	#name : #TKTArchetypedTaskExecution,
	#superclass : #TKTFutureExecution,
	#instVars : [
		'id'
	],
	#category : #'TaskItForkIt-Task'
}

{ #category : #evaluating }
TKTArchetypedTaskExecution >> deployFailure: error [
	future deployFailure: error
]

{ #category : #evaluating }
TKTArchetypedTaskExecution >> deploySuccess: aValue [
	future deploySuccess: aValue
]

{ #category : #evaluating }
TKTArchetypedTaskExecution >> doExecuteTask [
	[ runner doRemoteExecute: self ]
		on: Error
		do: [ :error | future deployFailure: error freeze ]
]

{ #category : #evaluating }
TKTArchetypedTaskExecution >> id [
	^ id
]

{ #category : #evaluating }
TKTArchetypedTaskExecution >> id: anId [
	id := anId 
]

{ #category : #evaluating }
TKTArchetypedTaskExecution >> task [
	^ task
]
