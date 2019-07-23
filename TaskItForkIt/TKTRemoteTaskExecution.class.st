"
The archetyped task execution relies on the runner as dispatcher to the proper backend to the remote process
"
Class {
	#name : #TKTRemoteTaskExecution,
	#superclass : #TKTFutureExecution,
	#instVars : [
		'id',
		'backend',
		'process'
	],
	#category : #'TaskItForkIt-Task'
}

{ #category : #evaluating }
TKTRemoteTaskExecution >> backend: aBackend [
	backend := aBackend
]

{ #category : #remoteExtention }
TKTRemoteTaskExecution >> deployValue: aValue [
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
TKTRemoteTaskExecution >> doExecuteTask [
	[ backend
		sendTaskAndProcessResponse: (TKTTask valuable: task valuable)
		id: id
		serializer: task serializerSelector ]
		on: Error
		do: [ :error | future deployFailure: error freeze ]
]

{ #category : #evaluating }
TKTRemoteTaskExecution >> id [
	^ id
]

{ #category : #evaluating }
TKTRemoteTaskExecution >> id: anId [
	id := anId 
]

{ #category : #evaluating }
TKTRemoteTaskExecution >> initialize [
	super initialize.
	process := WeakArray new: 1
]

{ #category : #evaluating }
TKTRemoteTaskExecution >> noteRunningOn: aRunner [ 
 	process at:1 put: aRunner.
]

{ #category : #evaluating }
TKTRemoteTaskExecution >> task [
	^ task
]

{ #category : #evaluating }
TKTRemoteTaskExecution >> useFuel [
	task useFuel
]

{ #category : #evaluating }
TKTRemoteTaskExecution >> useSton [
	task useSton
]

{ #category : #evaluating }
TKTRemoteTaskExecution >> useXStoned [ 
	task useXStoned
]
