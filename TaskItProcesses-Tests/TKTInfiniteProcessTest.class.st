Class {
	#name : #TKTInfiniteProcessTest,
	#superclass : #TKTTestCase,
	#instVars : [
		'process',
		'processStarted',
		'processFinishing',
		'processCancelled',
		'contextCancelled',
		'processSuspended',
		'processResumed'
	],
	#category : 'TaskItProcesses-Tests'
}

{ #category : #'as yet unclassified' }
TKTInfiniteProcessTest >> deny: anObject equals: anOtherObject [
	^ self assert: (anObject = anOtherObject) not
]

{ #category : #'as yet unclassified' }
TKTInfiniteProcessTest >> iterateForEver [
	[ true ]
		whileTrue: [ 20 milliSeconds wait.
			self logCr: 'it ' ]
]

{ #category : #setup }
TKTInfiniteProcessTest >> processCancelled: aProcessAnn [
	processCancelled := aProcessAnn process.
	contextCancelled := aProcessAnn suspendedContext.
]

{ #category : #accessing }
TKTInfiniteProcessTest >> processFinishing: aProcessFinishingAnnouncement [
	processFinishing := aProcessFinishingAnnouncement process.
]

{ #category : #accessing }
TKTInfiniteProcessTest >> processResumed: aProcessAnnouncement [
	processResumed := aProcessAnnouncement process.
]

{ #category : #accessing }
TKTInfiniteProcessTest >> processStarted: aProcessStartedAnnouncement [
	aProcessStartedAnnouncement process = process
		ifTrue: [ processStarted := aProcessStartedAnnouncement process ]
]

{ #category : #accessing }
TKTInfiniteProcessTest >> processSuspended: aProcessAnnouncement [
	processSuspended := aProcessAnnouncement process.
]

{ #category : #accessing }
TKTInfiniteProcessTest >> runAndUnreference [
	process run.
	process := nil.
]

{ #category : #setup }
TKTInfiniteProcessTest >> setUp [
	| messageSend |
	super setUp.
	TKTProcess uniqueAnnouncer when: TKTProcessStarted send: #processStarted: to: self.
	TKTProcess uniqueAnnouncer when: TKTProcessFinishing send: #processFinishing: to: self.
	TKTProcess uniqueAnnouncer
		when: TKTProcessCancelledByThirdThread
		send: #processCancelled:
		to: self.
	TKTProcess uniqueAnnouncer when: TKTProcessSuspended send: #processSuspended: to: self.
	TKTProcess uniqueAnnouncer when: TKTProcessResumed send: #processResumed: to: self.
	TKTProcess uniqueAnnouncer
		when: TKTProcessCancelledByThirdThread
		send: #processCancelled:
		to: self.
	messageSend := MessageSend receiver: self selector: #iterateForEver.
	process := TKTProcess forMessageSend: messageSend
]

{ #category : #'as yet unclassified' }
TKTInfiniteProcessTest >> tearDown [
	super tearDown.
	TKTProcess uniqueAnnouncer unsubscribe: self.
	TKTProcess resetAnnouncer.
	process
		ifNotNil: [ 
			process cancelIfNotRunning: [  ].
			20 milliSeconds wait ]
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testForksForkAtActivePriority [
	| priority |
	priority := process
		run;
		priority.
	self assert: priority equals: Processor activePriority
]

{ #category : #'as yet unclassified' }
TKTInfiniteProcessTest >> testProcessCancelledAnnouncementNotReceivedBeforeRun [
	self assert: processCancelled equals: nil
]

{ #category : #'as yet unclassified' }
TKTInfiniteProcessTest >> testProcessCancelledAnnouncementReceivedAfterCancelling [
	process run.
	20 milliSeconds wait.
	self assert: processCancelled equals: nil.
	process cancel.
	20 milliSeconds wait.
	self assert: processCancelled equals: process.
	self assert: contextCancelled isNotNil
]

{ #category : #'as yet unclassified' }
TKTInfiniteProcessTest >> testProcessFinishesAfterBeingCancelled [
	process run.
	20 milliSeconds wait.
	self assert: process isRunning.
	process cancel.
	20 milliSeconds wait.
	self deny: process isRunning.
]

{ #category : #'as yet unclassified' }
TKTInfiniteProcessTest >> testProcessFinishingAndStartedAnnouncementsContainsTheSameProcess [
	process run.
	
	process cancel.
	self assert: processFinishing equals: processStarted.
]

{ #category : #'as yet unclassified' }
TKTInfiniteProcessTest >> testProcessFinishingAnnouncementNotReceivedBeforeRun [
	self assert: processFinishing equals: nil
]

{ #category : #'as yet unclassified' }
TKTInfiniteProcessTest >> testProcessFinishingAnnouncementReceivedAfterCancelling [
	process run.
	20 milliSeconds wait.
	self assert: processFinishing equals: nil.
	process cancel.
	20 milliSeconds wait.
	self assert: processFinishing equals: process.
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessIsNotRunningBeforeRun [
	self deny: process isRunning.
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessIsNotRunningBeforeRunForIfRunning [
	process ifRunning: [ self assert: false ] ifNotRunning: [ self assert: true ]
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessIsNotSuspendedBeforeRun [
	self deny: process isSuspended.
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessIsRunningJustAfterRun [
	process run.
	self assert: process isRunning.
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessIsRunningJustAfterRunForIfRunning [
	process run.
	process ifRunning: [ self assert: true ] ifNotRunning: [ self assert: false ]
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessResumedAnnouncementNotReceivedAfterSecondResume [
	process run.
	20 milliSeconds wait.
	process suspend.
	process resume.
	processResumed := nil.
	process resume.
	self assert: processResumed equals: nil
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessResumedAnnouncementNotReceivedAfterSuspend [
	process run.
	20 milliSeconds wait.
	process suspend.
	self assert: processResumed equals: nil
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessResumedAnnouncementNotReceivedBeforeRun [
	self assert: processResumed equals: nil
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessResumedAnnouncementNotReceivedMeanwhileRunning [
	process run.
	20 milliSeconds wait.
	self assert: processResumed equals: nil
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessResumedAnnouncementReceivedAfterResume [
	process run.
	20 milliSeconds wait.
	process suspend.
	process resume.
	self assert: processResumed equals: process
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessStartedAnnouncementNotReceivedBeforeRun [
	self assert: processStarted equals: nil
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessStartedAnnouncementReceivedAfterRun [
	process run.
	20 milliSeconds wait.
	self assert: processStarted equals: process
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessSuspendedAnnouncementNotReceivedAfterResume [
	process run.
	20 milliSeconds wait.
	process suspend.
	processSuspended := nil.
	process resume.
	self assert: processSuspended equals: nil
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessSuspendedAnnouncementNotReceivedAfterSecondSuspend [
	process run.
	20 milliSeconds wait.
	process suspend.
	processSuspended := nil.
	process suspend.
	self assert: processResumed equals: nil
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessSuspendedAnnouncementNotReceivedBeforeRun [
	self assert: processSuspended equals: nil
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessSuspendedAnnouncementNotReceivedMeanwhileRunning [
	process run.
	20 milliSeconds wait.
	self assert: processResumed equals: nil
]

{ #category : #'parallel running test' }
TKTInfiniteProcessTest >> testProcessSuspendedAnnouncementReceivedAfterSuspend [
	process run.
	20 milliSeconds wait.
	process suspend.
	self assert: processSuspended equals: process
]

{ #category : #'low-level tests' }
TKTInfiniteProcessTest >> testTKTMessageSendContextReferencesToSpecialMethod [
	| context |
	context := process createContext.
	self assert: context method selector equals: #privateExecuteAndFinalizeProcess
]
