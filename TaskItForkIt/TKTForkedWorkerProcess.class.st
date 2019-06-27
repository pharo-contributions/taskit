"
Worker Process This runner is based in a backend in which it delegates. 
"
Class {
	#name : #TKTForkedWorkerProcess,
	#superclass : #TKTWorkerProcess,
	#instVars : [
		'url',
		'imageProcess',
		'backend'
	],
	#category : #'TaskItForkIt-Worker'
}

{ #category : #'instance creation' }
TKTForkedWorkerProcess >> backend: aBackend [
	backend := aBackend
]

{ #category : #accessing }
TKTForkedWorkerProcess >> deploy: aValue into: anArchetypedTaskExecution [
	aValue isException
		ifTrue: [ anArchetypedTaskExecution deployFailure: aValue ]
		ifFalse: [ anArchetypedTaskExecution deploySuccess: aValue ]
]

{ #category : #accessing }
TKTForkedWorkerProcess >> doRemoteExecute: aTaskExecution [
	^ backend
		sendTaskAndProcessResponse: (TKTTask valuable: aTaskExecution task valuable)
		id: aTaskExecution id
]

{ #category : #accessing }
TKTForkedWorkerProcess >> executeTask: aTaskExecution [
	aTaskExecution runner: self.
	super executeTask: aTaskExecution
]

{ #category : #accessing }
TKTForkedWorkerProcess >> isAlive [
	^ backend isAlive
]

{ #category : #accessing }
TKTForkedWorkerProcess >> isFree [
	^ backend isFree
]

{ #category : #accessing }
TKTForkedWorkerProcess >> isRunning [
	^ super isRunning and: [ self isAlive ]
]
