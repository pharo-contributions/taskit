Class {
	#name : #TKTFutureStream,
	#superclass : #TKTFuture,
	#category : #'TaskIt-Futures'
}

{ #category : #deployment }
TKTFutureStream >> deploySuccess: aValue [

	result isFinished 
		ifTrue: [ result value add: aValue ]
		ifFalse: [ 
			self installFutureResult: (TKTFutureSuccess new value: (OrderedCollection with: aValue)) ].

	resultCallbacks
		do: [ :each | self scheduleCallbackTask: [ each value: aValue ] ].
	valueSemaphore signal
]

{ #category : #deployment }
TKTFutureStream >> waitForElements: aSize timeout: aTimeout [

	| remainingTime startTime expired |

	startTime := Time millisecondClockValue.  	
	remainingTime := aTimeout asMilliSeconds.

	[ remainingTime <= 0 or: [ self isFinished and: [ result value size >= aSize ] ] ]
		whileFalse: [ 
			expired := valueSemaphore waitTimeoutMSecs: remainingTime.
			expired ifTrue: [ TKTTimeoutException signal ] ].

	^ result value
]
