"
This is an announcement that contains a process. Is the root of the lowlevel announcement API. Since it is a subclass of SystemAnnouncement, it inherits the timestamp management
"
Class {
	#name : #TKTProcessAnnouncement,
	#superclass : #SystemAnnouncement,
	#instVars : [
		'process'
	],
	#category : 'TaskItProcesses'
}

{ #category : #'as yet unclassified' }
TKTProcessAnnouncement class >> forProcess: aProcess [
	^ self new
		process: aProcess;
		yourself
]

{ #category : #testing }
TKTProcessAnnouncement class >> handlesAnnouncement: anAnnouncement [
	"The receiver acts as a filter to determine whether subscribers who used the receiver as signaling tag (event identifier class or symbol) should receive incoming announcement. In particular, registering to a superclass will receive the announcements from all subclasses."

	^ anAnnouncement class == self
]

{ #category : #accessing }
TKTProcessAnnouncement >> process [
	^ process
]

{ #category : #accessing }
TKTProcessAnnouncement >> process: aTKTProcess [
	process := aTKTProcess
]
