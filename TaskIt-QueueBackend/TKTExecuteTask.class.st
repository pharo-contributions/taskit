Class {
	#name : #TKTExecuteTask,
	#superclass : #TKTAbstractEvent,
	#instVars : [
		'valuable'
	],
	#category : #'TaskIt-QueueBackend-Messages'
}

{ #category : #accesing }
TKTExecuteTask >> handleException: exception onRunner: runner [
	
	| event |
	event := TKTErrorInTask new
		uuid: uuid;
		exception: exception;
		yourself.
			
	runner sendToMaster: event.
		
	
]

{ #category : #accesing }
TKTExecuteTask >> processEvent: runner [
	| returnValue event |
	[ returnValue := valuable value ]
		on: Exception
		do: [ :e | ^ self handleException: e onRunner: runner ].
	event := TKTReturnTask new.
	event uuid: uuid.
	event value: returnValue.
	
	runner sendToMaster: event
]

{ #category : #accesing }
TKTExecuteTask >> uuid: anUuid [ 
	uuid := anUuid
]

{ #category : #accessing }
TKTExecuteTask >> valuable: aBlockClosure [ 
	valuable := aBlockClosure
]
