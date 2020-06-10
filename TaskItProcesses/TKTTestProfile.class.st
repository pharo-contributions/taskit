"
A profile for testing
"
Class {
	#name : #TKTTestProfile,
	#superclass : #TKTProfile,
	#category : #TaskItProcesses
}

{ #category : #private }
TKTTestProfile class >> priority [

	^ -1
]

{ #category : #private }
TKTTestProfile class >> profileValues [

	^ {(#debugging -> false).
		(#runner -> TKTCommonQueueWorkerPool createDefault).
		(#poolWorkerProcess -> TKTWorkerProcess).
		(#process -> Process).
		(#errorHandler -> TKTExceptionHandler).
		(#watchDog -> TKTWatchDog onDuty).
		(#processProvider -> TKTTaskItProcessProvider new).
		(#serviceManager -> TKTServiceManager new)} asDictionary
]
