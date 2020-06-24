"
A profile for development.
"
Class {
	#name : #TKTDevelopmentProfile,
	#superclass : #TKTProfile,
	#category : #TaskItProcesses
}

{ #category : #private }
TKTDevelopmentProfile class >> priority [

	^ 100
]

{ #category : #private }
TKTDevelopmentProfile class >> profileValues [

	^ {(#debugging -> true).
		(#runner -> TKTCommonQueueWorkerPool createDefault).
		(#poolWorkerProcess -> TKTDebuggWorkerProcess).
		(#process -> TKTRawProcess).
		(#watchDog -> TKTWatchDog onDuty).
		(#errorHandler -> TKTDebuggerExceptionHandler).
		(#processProvider -> TKTTaskItProcessProvider new).
		(#serviceManager -> TKTServiceManager new)} asDictionary
]
