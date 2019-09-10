Class {
	#name : #TKTReturnTask,
	#superclass : #TKTAbstractEvent,
	#instVars : [
		'value'
	],
	#category : #'TaskIt-QueueBackend-Messages'
}

{ #category : #accessing }
TKTReturnTask >> processEvent: aQueueBackendRunner [

	aQueueBackendRunner notifyTask: uuid returnValue: value.

]

{ #category : #accessing }
TKTReturnTask >> value: aValue [

	value := aValue
]
