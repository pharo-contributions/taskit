"
The archetyped task execution relies on the runner as dispatcher to the proper backend to the remote process
"
Class {
	#name : #TKTArchetypedTaskExecution,
	#superclass : #TKTFutureExecution,
	#instVars : [
		'id',
		'backend',
		'process'
	],
	#category : #'TaskItForkIt-Task'
}

{ #category : #evaluating }
TKTArchetypedTaskExecution >> backend: aBackend [
	backend := aBackend
]

{ #category : #remoteExtention }
TKTArchetypedTaskExecution >> deployValue: aValue [
	| deployingTask |
	deployingTask := (aValue isException
		ifTrue: [ MessageSend
				receiver: future
				selector: #deployFailure:
				argument: aValue ]
		ifFalse: [ MessageSend
				receiver: future
				selector: #deploySuccess:
				argument: aValue ]) asTask.
	(runner future: deployingTask)
		onFailureDo: [ :e | deployingTask value ]
]

{ #category : #evaluating }
TKTArchetypedTaskExecution >> doExecuteTask [
	[ backend isAlive
		ifTrue: [ backend
				sendTaskAndProcessResponse: (TKTTask valuable: task valuable)
				id: id
				serializer: task serializerSelector ]
		ifFalse: [self halt. TKTRetryException signal: 'Image is dead!' ] ]
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
TKTArchetypedTaskExecution >> initialize [
	super initialize.
	process := WeakArray new: 1
]

{ #category : #evaluating }
TKTArchetypedTaskExecution >> noteRunningOn: aRunner [ 
 	process at:1 put: aRunner.
]

{ #category : #evaluating }
TKTArchetypedTaskExecution >> task [
	^ task
]

{ #category : #evaluating }
TKTArchetypedTaskExecution >> useFuel [
	task useFuel
]

{ #category : #evaluating }
TKTArchetypedTaskExecution >> useSton [
	task useSton
]

{ #category : #evaluating }
TKTArchetypedTaskExecution >> useXStoned [ 
	task useXStoned
]
