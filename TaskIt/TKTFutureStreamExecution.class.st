Class {
	#name : #TKTFutureStreamExecution,
	#superclass : #TKTFutureExecution,
	#category : #'TaskIt-Futures'
}

{ #category : #testing }
TKTFutureStreamExecution >> isBroadcast [

	^ true
]

{ #category : #initialization }
TKTFutureStreamExecution >> newFuture [

	^ TKTFutureStream new
]
