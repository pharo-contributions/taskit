"
This class is a specific wrapper for process, used strictly for system processes. 
"
Class {
	#name : #TKTSystemProcessModel,
	#superclass : #Object,
	#instVars : [
		'process',
		'actionIcon'
	],
	#category : 'TaskItBrowser-Widget'
}

{ #category : #'instance creation' }
TKTSystemProcessModel class >> on: aProcess [
	^ self new
		process: aProcess;
		yourself
]

{ #category : #construction }
TKTSystemProcessModel class >> systemProcesses [
	^ self wellKnownProcess collect: [ :process | self on: process ]
]

{ #category : #query }
TKTSystemProcessModel class >> wellKnownProcess [
	^ {Smalltalk lowSpaceWatcherProcess.
	WeakArray runningFinalizationProcess.
	Processor backgroundProcess.
	InputEventFetcher default fetcherProcess.
	UIManager default uiProcess.
	Smalltalk globals at: #SoundPlayer ifPresent: [ :sp | sp playerProcess ].
	Smalltalk globals at: #CPUWatcher ifPresent: [ :cw | cw currentWatcherProcess ].
	Delay schedulingProcess} reject: #isNil
]

{ #category : #accessing }
TKTSystemProcessModel >> actionOn: aBrowser [
	^ actionIcon ifNil: [ actionIcon := self createActionIconOn: aBrowser ]
]

{ #category : #factory }
TKTSystemProcessModel >> createActionIconOn: aBrowser [
	^ Smalltalk ui icons iconNamed: #flagIcon
]

{ #category : #process }
TKTSystemProcessModel >> model [
	^ process
]

{ #category : #accessing }
TKTSystemProcessModel >> name [
	^ process name , ' ( ' , process asString , ')'
]

{ #category : #accessing }
TKTSystemProcessModel >> priority [
	^ process priority
]

{ #category : #accessing }
TKTSystemProcessModel >> process: aProcess [
	process := aProcess
]

{ #category : #accessing }
TKTSystemProcessModel >> state [
	^ process isActiveProcess
		ifTrue: [ 'Running' ]
		ifFalse: [ 
			(process isTerminated or: [ process isTerminating ])
				ifTrue: [ 'Terminated' ]
				ifFalse: [ 'Suspended' ] ]
]
