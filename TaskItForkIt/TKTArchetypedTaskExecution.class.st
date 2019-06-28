"
The archetyped task execution relies on the runner as dispatcher to the proper backend to the remote process
"
Class {
	#name : #TKTArchetypedTaskExecution,
	#superclass : #TKTFutureExecution,
	#instVars : [
		'id',
		'backend'
	],
	#category : #'TaskItForkIt-Task'
}

{ #category : #evaluating }
TKTArchetypedTaskExecution >> backend: aBackend [
	backend := aBackend
]

{ #category : #evaluating }
TKTArchetypedTaskExecution >> deployFailure: error [
	future deployFailure: error
]

{ #category : #evaluating }
TKTArchetypedTaskExecution >> deploySuccess: aValue [
	future deploySuccess: aValue
]

{ #category : #remoteExtention }
TKTArchetypedTaskExecution >> deployValue: aValue [
	runner deploy: aValue into: self
]

{ #category : #evaluating }
TKTArchetypedTaskExecution >> doExecuteTask [
	[ backend
		sendTaskAndProcessResponse: (TKTTask valuable: task valuable)
		id: id ]
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
