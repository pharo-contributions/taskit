Class {
	#name : #TKTMessageSendProcessTest,
	#superclass : #TKTTestCase,
	#instVars : [
		'dummyObject',
		'process',
		'processStarted',
		'processFinishing'
	],
	#category : 'TaskItProcesses-Tests'
}

{ #category : #accessing }
TKTMessageSendProcessTest >> processFinishing: aProcessFinishingAnnouncement [
	process = aProcessFinishingAnnouncement process
		ifTrue: [ processFinishing := aProcessFinishingAnnouncement process ]
]

{ #category : #accessing }
TKTMessageSendProcessTest >> processStarted: aProcessStartedAnnouncement [
	process = aProcessStartedAnnouncement process
		ifTrue: [ processStarted := aProcessStartedAnnouncement process ]
]

{ #category : #setup }
TKTMessageSendProcessTest >> setUp [
	| messageSend |
	super setUp.
	TKTProcess resetAnnouncer.
	TKTProcess uniqueAnnouncer when: TKTProcessStarted send: #processStarted: to: self.
	TKTProcess uniqueAnnouncer when: TKTProcessFinishing send: #processFinishing: to: self.
	dummyObject := Dictionary new.
	messageSend := MessageSend
		receiver: dummyObject
		selector: #at:put:
		arguments: {'key' . 'value'}.
	process := TKTProcess forMessageSend: messageSend
]

{ #category : #setup }
TKTMessageSendProcessTest >> tearDown [
	super tearDown.
	TKTProcess uniqueAnnouncer unsubscribe: self.
	TKTProcess resetAnnouncer
]

{ #category : #'parallel running test' }
TKTMessageSendProcessTest >> testForkedExecutionResultsIntoTheSameValueAsValue [
	process run.
	20 milliSeconds wait. 
	self assert: (dummyObject at: 'key') equals: 'value'
	

	
]

{ #category : #'parallel running test' }
TKTMessageSendProcessTest >> testForksForkAtActivePriority [
	| priority |
	priority := process
		run;
		priority.
	self assert: priority equals: Processor activePriority
]

{ #category : #'parallel running test' }
TKTMessageSendProcessTest >> testProcessFinishes [
	process run.
	20 milliSeconds wait.
	self deny: process isRunning.
]

{ #category : #tests }
TKTMessageSendProcessTest >> testProcessFinishingAndStartedAnnouncementsContainsTheSameProcess [
	process run.
	20 milliSeconds wait.
	self assert: processFinishing equals: processStarted.
]

{ #category : #tests }
TKTMessageSendProcessTest >> testProcessFinishingAnnouncementNotReceivedBeforeRun [
	self assert: processFinishing equals: nil
]

{ #category : #tests }
TKTMessageSendProcessTest >> testProcessFinishingAnnouncementReceivedAfterRun [
	process run.
	20 milliSeconds wait.
	self assert: processFinishing equals: process
]

{ #category : #'parallel running test' }
TKTMessageSendProcessTest >> testProcessIsNotRunningBeforeRun [
	self deny: process isRunning.
]

{ #category : #'parallel running test' }
TKTMessageSendProcessTest >> testProcessIsNotRunningBeforeRunForIfRunning [
	process ifRunning: [ self assert: false ] ifNotRunning: [ self assert: true ]
]

{ #category : #'parallel running test' }
TKTMessageSendProcessTest >> testProcessIsRunningJustAfterRun [
	process run.
	self assert: process isRunning.
]

{ #category : #'parallel running test' }
TKTMessageSendProcessTest >> testProcessIsRunningJustAfterRunForIfRunning [
	process run.
	process ifRunning: [ self assert: true ] ifNotRunning: [ self assert: false ]
]

{ #category : #'parallel running test' }
TKTMessageSendProcessTest >> testProcessStartedAnnouncementNotReceivedBeforeRun [
	self assert: processStarted equals: nil
]

{ #category : #'parallel running test' }
TKTMessageSendProcessTest >> testProcessStartedAnnouncementReceivedAfterRun [
	process run.
	20 milliSeconds wait.
	self assert: processStarted equals: process
]

{ #category : #'low-level tests' }
TKTMessageSendProcessTest >> testTKTMessageSendContextReferencesToSpecialMethod [
	| context |
	context := process createContext.
	self assert: context method selector equals: #privateExecuteAndFinalizeProcess
]
