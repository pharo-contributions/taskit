Class {
	#name : #TKTFutureRetry,
	#superclass : #Object,
	#instVars : [
		'lapseBetweenRetries',
		'nextRetryBlock',
		'doneBlock'
	],
	#category : #TaskItRetry
}

{ #category : #'instance creation' }
TKTFutureRetry class >> every: lapseDuration for: totalDuration [ 
	
	^ self new
		lapseBetweenRetries: lapseDuration;
		nextRetryBlock: [ self every: lapseDuration for: (totalDuration - lapseDuration) ];
		doneBlock: [ lapseDuration > totalDuration ];
		yourself
]

{ #category : #accessing }
TKTFutureRetry >> doneBlock: aBlockClosure [

	doneBlock := aBlockClosure
]

{ #category : #testing }
TKTFutureRetry >> isDone [
	
	^ doneBlock value
]

{ #category : #accessing }
TKTFutureRetry >> lapseBetweenRetries: aDuration [

	lapseBetweenRetries := aDuration 
]

{ #category : #iterating }
TKTFutureRetry >> next [
	
	self isDone ifTrue: [ self error: 'retries finished' ].
	^ nextRetryBlock value
]

{ #category : #accessing }
TKTFutureRetry >> nextRetryBlock: aBlockClosure [ 

	nextRetryBlock := aBlockClosure
]

{ #category : #iterating }
TKTFutureRetry >> waitLapse [
	
	^ lapseBetweenRetries wait
]
