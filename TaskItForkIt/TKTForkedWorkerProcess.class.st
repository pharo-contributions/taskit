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
TKTForkedWorkerProcess >> doRemoteExecute: aTask [
	^ backend
		sendTaskAndProcessResponse: (TKTTask valuable: aTask valuable)
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
