Class {
	#name : #TKTNewTask,
	#superclass : #Object,
	#instVars : [
		'uuid',
		'blockCode'
	],
	#category : #'TaskIt-QueueBackend-Messages'
}

{ #category : #accessing }
TKTNewTask >> blockCode: aBlockClosure [ 
	blockCode := aBlockClosure
]

{ #category : #accesing }
TKTNewTask >> processEvent: slaveRunner [

	| returnValue event |
	returnValue := blockCode value.
	event := TKTReturnTask new.
	event uuid: uuid.
	event value: returnValue.	

	slaveRunner responseEvent: event
]

{ #category : #accesing }
TKTNewTask >> uuid: anUuid [ 
	uuid := anUuid
]
