"
This announcement tells that the process has been stopped from other thread, meaning that it was really cancelled and not just cancelled by it self as a way to stop. 

In this case the announcement has the process reference and the suspended context where the thread was stopped.
"
Class {
	#name : #TKTProcessCancelledByThirdThread,
	#superclass : #TKTProcessAnnouncement,
	#instVars : [
		'suspendedContext'
	],
	#category : 'TaskItProcesses'
}

{ #category : #'as yet unclassified' }
TKTProcessCancelledByThirdThread class >> forProcess: aProcess andSuspendedContext: aSuspendedContext [
	^ (super forProcess: aProcess)
		suspendedContext: aSuspendedContext;
		yourself
]

{ #category : #accessing }
TKTProcessCancelledByThirdThread >> suspendedContext [
	^ suspendedContext
]

{ #category : #accessing }
TKTProcessCancelledByThirdThread >> suspendedContext: aSuspendedContext [
	suspendedContext := aSuspendedContext
]
