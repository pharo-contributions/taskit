Class {
	#name : #TKTExecuteTask,
	#superclass : #TKTAbstractEvent,
	#instVars : [
		'blockCode'
	],
	#category : #'TaskIt-QueueBackend-Messages'
}

{ #category : #accessing }
TKTExecuteTask >> blockCode: aBlockClosure [ 
	blockCode := aBlockClosure
]

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

	[ returnValue := blockCode value ]
		on: Error
		do: [ :e | 
			self handleException: e onRunner: runner.
			^ self ].

	event := TKTReturnTask new.
	event uuid: uuid.
	event value: returnValue.
	runner sendToMaster: event
]

{ #category : #accesing }
TKTExecuteTask >> uuid: anUuid [ 
	uuid := anUuid
]
