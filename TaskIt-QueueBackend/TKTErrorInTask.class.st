Class {
	#name : #TKTErrorInTask,
	#superclass : #TKTAbstractEvent,
	#instVars : [
		'exception'
	],
	#category : #'TaskIt-QueueBackend-Messages'
}

{ #category : #accessing }
TKTErrorInTask >> exception: anException [

	exception:= anException 
]

{ #category : #accessing }
TKTErrorInTask >> processEvent: aQueueBackendRunner [

	aQueueBackendRunner notifyFailure: uuid exception: exception.

]
