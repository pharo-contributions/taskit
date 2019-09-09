Class {
	#name : #TKTReturnTask,
	#superclass : #Object,
	#instVars : [
		'uuid',
		'value'
	],
	#category : #'TaskIt-QueueBackend-Messages'
}

{ #category : #accessing }
TKTReturnTask >> processEvent: aQueueBackendRunner [

	aQueueBackendRunner notifyTask: uuid returnValue: value.

]

{ #category : #accessing }
TKTReturnTask >> uuid: anUuid [

	uuid := anUuid
]

{ #category : #accessing }
TKTReturnTask >> value: aValue [

	value := aValue
]
