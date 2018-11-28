Class {
	#name : #TKTRetry,
	#superclass : #Object,
	#instVars : [
		'lapseBetweenRetries',
		'nextRetryBlock',
		'doneBlock'
	],
	#category : 'TaskItRetry'
}

{ #category : #'instance creation' }
TKTRetry class >> every: lapseDuration for: totalDuration [ 
	
	^ self new
		lapseBetweenRetries: lapseDuration;
		nextRetryBlock: [ self every: lapseDuration for: (totalDuration - lapseDuration) ];
		doneBlock: [ lapseDuration > totalDuration ];
		yourself
]

{ #category : #accessing }
TKTRetry >> doneBlock: aBlockClosure [

	doneBlock := aBlockClosure
]

{ #category : #testing }
TKTRetry >> isDone [
	
	^ doneBlock value
]

{ #category : #accessing }
TKTRetry >> lapseBetweenRetries: aDuration [

	lapseBetweenRetries := aDuration 
]

{ #category : #iterating }
TKTRetry >> next [
	
	self isDone ifTrue: [ self error: 'retries finished' ].
	^ nextRetryBlock value
]

{ #category : #accessing }
TKTRetry >> nextRetryBlock: aBlockClosure [ 

	nextRetryBlock := aBlockClosure
]

{ #category : #iterating }
TKTRetry >> waitLapse [
	
	^ lapseBetweenRetries wait
]
