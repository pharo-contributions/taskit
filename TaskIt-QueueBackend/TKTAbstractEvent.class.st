Class {
	#name : #TKTAbstractEvent,
	#superclass : #Object,
	#instVars : [
		'uuid'
	],
	#category : #'TaskIt-QueueBackend-Messages'
}

{ #category : #accesing }
TKTAbstractEvent >> processEvent: runner [

	self subclassResponsibility 
]

{ #category : #accesing }
TKTAbstractEvent >> uuid: anUuid [ 
	uuid := anUuid
]
