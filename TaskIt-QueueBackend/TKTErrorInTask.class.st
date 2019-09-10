Class {
	#name : #TKTErrorInTask,
	#superclass : #TKTAbstractEvent,
	#instVars : [
		'serializedException'
	],
	#category : #'TaskIt-QueueBackend-Messages'
}

{ #category : #accessing }
TKTErrorInTask >> exception [
	
	^ FLMaterializer materializeFromByteArray: serializedException


]

{ #category : #accessing }
TKTErrorInTask >> exception: anException [
	serializedException := ByteArray
		streamContents: [ :s | FLSerializer serialize: anException on: s ].

]

{ #category : #accessing }
TKTErrorInTask >> processEvent: aQueueBackendRunner [

	aQueueBackendRunner notifyFailure: uuid exception: self exception.

]
