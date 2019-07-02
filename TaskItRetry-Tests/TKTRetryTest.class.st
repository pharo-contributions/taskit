Class {
	#name : #TKTRetryTest,
	#superclass : #TKTTestCase,
	#category : 'TaskItRetry-Tests'
}

{ #category : #tests }
TKTRetryTest >> testRetryEveryCanRetryAsManyTimesAsLapsesIsInsideTotal [

	| total lapse retry |
	total := 10 seconds.
	lapse := 1 second.
	retry := TKTFutureRetry every: lapse for: total.
	
	total / lapse timesRepeat: [ 
		self deny: retry isDone.
		retry := retry next ].
]

{ #category : #tests }
TKTRetryTest >> testRetryEveryCannotRetryOverNumberOfLapsesIsInsideTotal [

	| total lapse retry |
	total := 10 seconds.
	lapse := 1 second.
	retry := TKTFutureRetry every: lapse for: total.
	
	total / lapse timesRepeat: [ retry := retry next ].
	self assert: retry isDone.
	self should: [ retry next ] raise: Error
]

{ #category : #tests }
TKTRetryTest >> testRetryEveryIsDoneIfLapseTimeIsBiggerThanTotalRetryTime [

	self assert: (TKTFutureRetry every: 1 minute for: 10 seconds) isDone
]

{ #category : #tests }
TKTRetryTest >> testRetryEveryIsNotDoneIfLapseTimeIsSmallerThanTotalRetryTime [

	self deny: (TKTFutureRetry every: 1 second for: 10 seconds) isDone
]
