Class {
	#name : #TKTServiceTests,
	#superclass : #TKTTestCase,
	#instVars : [
		'service'
	],
	#category : #'TaskIt-Tests-Services'
}

{ #category : #tests }
TKTServiceTests >> tearDown [

	super tearDown.
	(service notNil and: [service isRunning]) ifTrue: [
		(service stop) waitForCompletion: 1 second ]
]

{ #category : #tests }
TKTServiceTests >> testPrioritySetAfterStart [
	|newPriority|
	service := TKTParameterizableService new.
	service name: 'test service'.
	newPriority := 32.
	self deny: service priority equals: newPriority.
	service start.
	service priority: newPriority.
	self assert: service priority equals: newPriority.
	self assert: service process priority equals: newPriority.

]

{ #category : #tests }
TKTServiceTests >> testPrioritySetBeforeStart [
	|initialPriority|
	service := TKTParameterizableService new.
	service name: 'test service'.
	initialPriority := 35.
	service priority: initialPriority.
	self assert: service priority equals: initialPriority.
	service start.
	self assert: service process priority equals: initialPriority.

]

{ #category : #tests }
TKTServiceTests >> testServiceIsKilledAfterStop [

	service := TKTParameterizableService new.
	service name: 'test service'.
	service start.
	(service stop) waitForCompletion: 2 second.
	
	self deny: service isRunning.
]

{ #category : #tests }
TKTServiceTests >> testServiceShouldHaveAName [

	self should: [TKTService new start] raise: Error
]

{ #category : #test }
TKTServiceTests >> testSignalIterationIsIgnoredNowAfterStop [
	| queue tinyDelay |
	tinyDelay := 5 milliSeconds asDelay.
	queue := AtomicSharedQueue new.
	service := TKTParameterizableService new
		name: 'test service';
		stepDelay: 50 milliSeconds;
		step: [ queue nextPut: 'iterated once more' ];
		yourself.

	"Start iterates once."
	service start.
	tinyDelay wait.
	self assert: queue size equals: 1.

	"Stop doesn't iterate again."
	service stop.
	tinyDelay wait.
	self assert: queue size equals: 1.

	"After #stop, the signal is ignored."
	service signalIterationNow.
	tinyDelay wait.
	self assert: queue size equals: 1.

]

{ #category : #test }
TKTServiceTests >> testSignalIterationNowIsIgnoredBeforeStart [
	| queue tinyDelay |
	tinyDelay := 5 milliSeconds asDelay.
	queue := AtomicSharedQueue new.
	service := TKTParameterizableService new
		name: 'test service';
		stepDelay: 50 milliSeconds;
		step: [ queue nextPut: 'iterated once more' ];
		yourself.

	"Before #start, the signal is ignored."
	service signalIterationNow.
	tinyDelay wait.
	self assert: queue size equals: 0.

]

{ #category : #test }
TKTServiceTests >> testSignalIterationNowKeepsNormalCycleAfterwards [
	| queue tinyDelay |
	tinyDelay := 5 milliSeconds asDelay.
	queue := AtomicSharedQueue new.
	service := TKTParameterizableService new
		name: 'test service';
		stepDelay: 50 milliSeconds;
		step: [ queue nextPut: 'iterated once more' ];
		yourself.

	"Start iterates once."
	service start.
	tinyDelay wait.
	self assert: queue size equals: 1.

	"Many signals (without yielding processor) only result in one single resumed iteration."
	20 timesRepeat: [ service signalIterationNow ].
	tinyDelay wait.
	self assert: queue size equals: 2.
	
	"Check it keeps normal behavior."
	service stepDelay wait.
	self assert: queue size equals: 3.
]

{ #category : #test }
TKTServiceTests >> testSignalIterationNowResumesCycle [
	| queue tinyDelay |
	tinyDelay := 5 milliSeconds asDelay.
	queue := AtomicSharedQueue new.
	service := TKTParameterizableService new
		name: 'test service';
		stepDelay: 50 milliSeconds;
		step: [ queue nextPut: 'iterated once more' ];
		yourself.

	"Start iterates once, and every time we signal, the next iteration is resumed (in advance)."
	service start.
	1 to: 5 do: [ :index | 
		service signalIterationNow.
		tinyDelay wait.
		self assert: queue size equals: index ].

]
