"
A profile for development.
"
Class {
	#name : #TKTDevelopmentProfile,
	#superclass : #TKTProfile,
	#category : #TaskItDebugger
}

{ #category : #private }
TKTDevelopmentProfile class >> priority [

	^ 100
]

{ #category : #accessing }
TKTDevelopmentProfile class >> profileName [
	
	^ #development
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
