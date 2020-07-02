"
A lightweight for development.
"
Class {
	#name : #TKTLightweigthProfile,
	#superclass : #TKTProfile,
	#category : #TaskItProcesses
}

{ #category : #private }
TKTLightweigthProfile class >> priority [

	^ -1
]

{ #category : #accessing }
TKTLightweigthProfile class >> profileName [
	
	^ #lightweigth
]

{ #category : #private }
TKTLightweigthProfile class >> profileValues [

	^ {(#debugging -> false).
		(#runner -> TKTWorker createDefault ).
		(#poolWorkerProcess -> TKTWorkerProcess).
		(#process -> Process).
		(#errorHandler -> TKTExceptionHandler).
		(#watchDog -> TKTWatchDog onDuty).
		(#processProvider -> TKTTaskItProcessProvider new).
		(#serviceManager -> TKTServiceManager new)} asDictionary
]
