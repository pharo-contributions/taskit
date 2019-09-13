Class {
	#name : #TKTMonitoredInstance,
	#superclass : #Object,
	#instVars : [
		'process',
		'lastHeartbeat'
	],
	#category : #'TaskIt-QueueBackend-watchdog'
}

{ #category : #accessing }
TKTMonitoredInstance >> isRunning [

	^ process isRunning
]

{ #category : #accessing }
TKTMonitoredInstance >> lastHeartbeat [
	^ lastHeartbeat
]

{ #category : #accessing }
TKTMonitoredInstance >> lastHeartbeat: anObject [
	lastHeartbeat := anObject
]

{ #category : #accessing }
TKTMonitoredInstance >> pid [ 

	^ (process instVarNamed: #processInfo) 
		ifNil: [ nil ] 
		ifNotNil: [ :x | x getHandle ifNotNil:[x dwProcessId] ]
]

{ #category : #accessing }
TKTMonitoredInstance >> process [
	^ process
]

{ #category : #accessing }
TKTMonitoredInstance >> process: anObject [
	process := anObject
]

{ #category : #accessing }
TKTMonitoredInstance >> terminate [

	^process terminate
]
