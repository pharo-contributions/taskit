Class {
	#name : #TKTFutureStreamExecution,
	#superclass : #TKTFutureExecution,
	#category : #'TaskIt-QueueBackend'
}

{ #category : #testing }
TKTFutureStreamExecution >> isBroadcast [

	^ true
]

{ #category : #initialization }
TKTFutureStreamExecution >> newFuture [

	^ TKTFutureStream new
]
